class Neovim < Formula
  desc "Ambitious Vim-fork focused on extensibility and agility"
  homepage "https://neovim.io"
  url "https://github.com/neovim/neovim/archive/v0.1.7.tar.gz"
  sha256 "d8f885d019b1ad608f36ae23b8f1b15b7e33585e16f7514666ab6c9809bb4b7e"
  head "https://github.com/neovim/neovim.git", :shallow => false

  option "with-dev", "Compile a Dev build. Enables debug information, logging,
        and optimizations that don't interfere with debugging."

  depends_on "cmake" => :build
  depends_on "libtool" => :build
  depends_on "automake" => :build
  depends_on "autoconf" => :build
  depends_on "pkg-config" => :build
  depends_on "libuv"
  depends_on "msgpack"
  depends_on "unibilium"
  depends_on "libtermkey"
  depends_on "libvterm"
  depends_on "gettext"
  depends_on :python => :recommended if OS.mac? && MacOS.version <= :snow_leopard

  resource "luv" do
    url "https://github.com/luvit/luv/archive/146f1ce4c08c3b67f604c9ee1e124b1cf5c15cf3.tar.gz"
    sha256 "3d537f8eb9fa5adb146a083eae22af886aee324ec268e2aa0fa75f2f1c52ca7a"
  end

  resource "luajit" do
    url "https://raw.githubusercontent.com/neovim/deps/master/opt/LuaJIT-2.0.4.tar.gz"
    sha256 "620fa4eb12375021bef6e4f237cbd2dd5d49e56beb414bee052c746beef1807d"
  end

  resource "luarocks" do
    url "https://github.com/keplerproject/luarocks/archive/5d8a16526573b36d5b22aa74866120c998466697.tar.gz"
    sha256 "cae709111c5701235770047dfd7169f66b82ae1c7b9b79207f9df0afb722bfd9"
  end

  def install
    ENV.deparallelize
    ENV["HOME"] = buildpath

    resources.each do |r|
      r.stage(buildpath/"deps-build/build/src/#{r.name}")
    end

    cd "deps-build" do
      ohai "Building third-party dependencies."
      system "cmake", "../third-party", "-DUSE_BUNDLED_BUSTED=OFF",
             "-DUSE_BUNDLED_GPERF=OFF",
             "-DUSE_BUNDLED_LIBUV=OFF",
             "-DUSE_BUNDLED_MSGPACK=OFF",
             "-DUSE_BUNDLED_UNIBILIUM=OFF",
             "-DUSE_BUNDLED_LIBTERMKEY=OFF",
             "-DUSE_BUNDLED_LIBVTERM=OFF",
             "-DUSE_BUNDLED_JEMALLOC=OFF",
             "-DUSE_EXISTING_SRC_DIR=ON", *std_cmake_args
      system "make", "VERBOSE=1"
    end

    mkdir "build" do
      ohai "Building Neovim."

      build_type = build.with?("dev") ? "Dev" : "RelWithDebInfo"
      cmake_args = std_cmake_args + ["-DDEPS_PREFIX=../deps-build/usr",
                                     "-DCMAKE_BUILD_TYPE=#{build_type}"]

      # Disable jemalloc, see https://github.com/neovim/neovim/issues/5681
      # cmake_args += ["-DENABLE_JEMALLOC=OFF"] if build.without?("jemalloc")
      cmake_args += ["-DENABLE_JEMALLOC=OFF"]

      if OS.mac?
        cmake_args += ["-DIconv_INCLUDE_DIRS:PATH=/usr/include",
                       "-DIconv_LIBRARIES:PATH=/usr/lib/libiconv.dylib"]
      end

      system "cmake", "..", *cmake_args
      system "make", "VERBOSE=1", "install"
    end
  end

  def caveats; <<-EOS.undent
      To run Neovim, use the "nvim" command (not "neovim"):
          nvim

      After installing or upgrading, run the "CheckHealth" command:
          :CheckHealth

      To use your existing Vim configuration:
          ln -s ~/.vim ~/.config/nvim
          ln -s ~/.vimrc ~/.config/nvim/init.vim
      See ':help nvim' for more information.

      Breaking changes (if any) are documented at:
          https://github.com/neovim/neovim/wiki/Following-HEAD

      For other questions:
          https://github.com/neovim/neovim/wiki/FAQ
    EOS
  end

  test do
    (testpath/"test.txt").write("Hello World from Vim!!")
    system bin/"nvim", "--headless", "-i", "NONE", "-u", "NONE", "+s/Vim/Neovim/g", "+wq", "test.txt"
    assert_equal "Hello World from Neovim!!", File.read("test.txt").strip
  end
end
