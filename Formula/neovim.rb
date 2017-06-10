class Neovim < Formula
  desc "Ambitious Vim-fork focused on extensibility and agility"
  homepage "https://neovim.io"

  stable do
    url "https://github.com/neovim/neovim/archive/v0.2.0.tar.gz"
    sha256 "72e263f9d23fe60403d53a52d4c95026b0be428c1b9c02b80ab55166ea3f62b5"
    resource "luarocks" do
      url "https://github.com/luarocks/luarocks/archive/5d8a16526573b36d5b22aa74866120c998466697.tar.gz"
      sha256 "cae709111c5701235770047dfd7169f66b82ae1c7b9b79207f9df0afb722bfd9"
    end
  end

  head do
    url "https://github.com/neovim/neovim.git", :shallow => false
    resource "luarocks" do
      url "https://github.com/luarocks/luarocks/archive/2.4.2.tar.gz"
      sha256 "eef88c2429c715a7beb921e4b1ba571dddb7c74a250fbb0d3cc0d4be7a5865d9"
    end
  end

  option "with-dev", "Compile a Dev build. Enables debug information, logging,
        and optimizations that don't interfere with debugging."

  depends_on "cmake" => :build
  depends_on "libtool" => :build
  depends_on "automake" => :build
  depends_on "autoconf" => :build
  depends_on "pkg-config" => :build
  depends_on "jemalloc" => :recommended
  depends_on "libuv"
  depends_on "msgpack"
  depends_on "unibilium"
  depends_on "libtermkey"
  depends_on "libvterm"
  depends_on "gettext"
  depends_on "gperf" => :recommended if OS.linux?
  depends_on "unzip" => :recommended if OS.linux?
  depends_on :python => :recommended if OS.mac? && MacOS.version <= :snow_leopard

  resource "luv" do
    version "1.9.1-0"
    url "https://github.com/luvit/luv/archive/1.9.1-0.tar.gz"
    sha256 "86a199403856018cd8e5529c8527450c83664a3d36f52d5253cbe909ea6c5a06"
  end

  resource "luajit" do
    url "https://raw.githubusercontent.com/neovim/deps/master/opt/LuaJIT-2.0.4.tar.gz"
    sha256 "620fa4eb12375021bef6e4f237cbd2dd5d49e56beb414bee052c746beef1807d"
  end

  def install
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
      ENV.deparallelize { system "make", "VERBOSE=1" }
    end

    mkdir "build" do
      ohai "Building Neovim."

      build_type = build.with?("dev") ? "Dev" : "RelWithDebInfo"
      cmake_args = std_cmake_args + ["-DDEPS_PREFIX=../deps-build/usr",
                                     "-DCMAKE_BUILD_TYPE=#{build_type}"]

      cmake_args += ["-DENABLE_JEMALLOC=OFF"] if build.without?("jemalloc")

      if OS.mac?
        cmake_args += ["-DJEMALLOC_LIBRARY=#{Formula["jemalloc"].opt_lib}/libjemalloc.a"] if build.with?("jemalloc")
        cmake_args += ["-DMSGPACK_LIBRARY=#{Formula["msgpack"].opt_lib}/libmsgpackc.2.dylib"]
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

      See ':help nvim-from-vim' for information about how to use
      your existing Vim configuration with Neovim.

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
