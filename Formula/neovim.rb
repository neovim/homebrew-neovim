class Neovim < Formula
  desc "Ambitious Vim-fork focused on extensibility and agility"
  homepage "https://neovim.io"

  stable do
    url "https://github.com/neovim/neovim/archive/v0.1.4.tar.gz"
    sha256 "bb7e359eb83db20c5ec5984b470b249372b6dcd813ae2ccf72c01cce560f93e9"

    # Third-party dependencies for latest release.
    resource "libuv" do
      url "https://github.com/libuv/libuv/archive/v1.8.0.tar.gz"
      sha256 "906e1a5c673c95cb261adeacdb7308a65b4a8f7c9c50d85f3021364951fa9cde"
    end

    resource "msgpack" do
      url "https://github.com/msgpack/msgpack-c/archive/cpp-1.0.0.tar.gz"
      sha256 "afda64ca445203bb7092372b822bae8b2539fdcebbfc3f753f393628c2bcfe7d"
    end

    resource "luajit" do
      url "https://raw.githubusercontent.com/neovim/deps/master/opt/LuaJIT-2.0.4.tar.gz"
      sha256 "620fa4eb12375021bef6e4f237cbd2dd5d49e56beb414bee052c746beef1807d"
    end

    resource "luarocks" do
      url "https://github.com/keplerproject/luarocks/archive/5d8a16526573b36d5b22aa74866120c998466697.tar.gz"
      sha256 "cae709111c5701235770047dfd7169f66b82ae1c7b9b79207f9df0afb722bfd9"
    end

    resource "unibilium" do
      url "https://github.com/mauke/unibilium/archive/v1.2.0.tar.gz"
      sha256 "623af1099515e673abfd3cae5f2fa808a09ca55dda1c65a7b5c9424eb304ead8"
    end

    resource "libtermkey" do
      url "https://github.com/neovim/libtermkey/archive/416adba8c000bd2a70efc881283249d03a56553b.tar.gz"
      sha256 "29cb598c9afc0d306a406df4a9c9aceeb5f6a58dfe690dccc7032834d6844f86"
    end

    resource "libvterm" do
      url "https://github.com/neovim/libvterm/archive/1b745d29d45623aa8d22a7b9288c7b0e331c7088.tar.gz"
      sha256 "3fc75908256c0d158d6c2a32d39f34e86bfd26364f5404b7d9c03bb70cdc3611"
    end

    resource "jemalloc" do
      url "https://github.com/jemalloc/jemalloc/releases/download/4.0.2/jemalloc-4.0.2.tar.bz2"
      sha256 "0d8a9c8a98adb6983e0ccb521d45d9db1656ef3e71d0b14fb333f2c8138f4611"
    end
  end

  head do
    url "https://github.com/neovim/neovim.git"

    # Third-party dependencies for latest repo revision.
    resource "libuv" do
      url "https://github.com/libuv/libuv/archive/v1.8.0.tar.gz"
      sha256 "906e1a5c673c95cb261adeacdb7308a65b4a8f7c9c50d85f3021364951fa9cde"
    end

    resource "luv" do
      url "https://github.com/luvit/luv/archive/146f1ce4c08c3b67f604c9ee1e124b1cf5c15cf3.tar.gz"
      sha256 "3d537f8eb9fa5adb146a083eae22af886aee324ec268e2aa0fa75f2f1c52ca7a"
    end

    resource "msgpack" do
      url "https://github.com/msgpack/msgpack-c/archive/cpp-1.0.0.tar.gz"
      sha256 "afda64ca445203bb7092372b822bae8b2539fdcebbfc3f753f393628c2bcfe7d"
    end

    resource "luajit" do
      url "https://raw.githubusercontent.com/neovim/deps/master/opt/LuaJIT-2.0.4.tar.gz"
      sha256 "620fa4eb12375021bef6e4f237cbd2dd5d49e56beb414bee052c746beef1807d"
    end

    resource "luarocks" do
      url "https://github.com/keplerproject/luarocks/archive/5d8a16526573b36d5b22aa74866120c998466697.tar.gz"
      sha256 "cae709111c5701235770047dfd7169f66b82ae1c7b9b79207f9df0afb722bfd9"
    end

    resource "unibilium" do
      url "https://github.com/mauke/unibilium/archive/v1.2.0.tar.gz"
      sha256 "623af1099515e673abfd3cae5f2fa808a09ca55dda1c65a7b5c9424eb304ead8"
    end

    resource "libtermkey" do
      url "https://github.com/neovim/libtermkey/archive/416adba8c000bd2a70efc881283249d03a56553b.tar.gz"
      sha256 "29cb598c9afc0d306a406df4a9c9aceeb5f6a58dfe690dccc7032834d6844f86"
    end

    resource "libvterm" do
      url "https://github.com/neovim/libvterm/archive/1b745d29d45623aa8d22a7b9288c7b0e331c7088.tar.gz"
      sha256 "3fc75908256c0d158d6c2a32d39f34e86bfd26364f5404b7d9c03bb70cdc3611"
    end

    resource "jemalloc" do
      url "https://github.com/jemalloc/jemalloc/releases/download/4.0.2/jemalloc-4.0.2.tar.bz2"
      sha256 "0d8a9c8a98adb6983e0ccb521d45d9db1656ef3e71d0b14fb333f2c8138f4611"
    end
  end

  option "with-release", "Compile in release mode"

  depends_on "cmake" => :build
  depends_on "libtool" => :build
  depends_on "automake" => :build
  depends_on "autoconf" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on :python => :recommended if OS.mac? and MacOS.version <= :snow_leopard

  def install
    ENV.deparallelize
    ENV["HOME"] = buildpath

    resources.each do |r|
      r.stage(buildpath/"deps-build/build/src/#{r.name}")
    end

    cd "deps-build" do
      ohai "Building third-party dependencies."
      system "cmake", "../third-party", "-DUSE_BUNDLED_BUSTED=OFF",
             "-DUSE_BUNDLED_LUV=OFF", "-DUSE_EXISTING_SRC_DIR=ON",
             *std_cmake_args
      system "make", "VERBOSE=1"
    end

    mkdir "build" do
      ohai "Building Neovim."

      build_type =
        if build.with?("release")
          "Release"
        else
          build.head? ? "Dev" : "RelWithDebInfo"
        end
      cmake_args = std_cmake_args + ["-DDEPS_PREFIX=../deps-build/usr",
                                     "-DCMAKE_BUILD_TYPE=#{build_type}"]
      if OS.mac?
        unless build.head?
          cmake_args += ["-DCMAKE_C_FLAGS_#{build_type.upcase}='-U_FORTIFY_SOURCE -D_FORTIFY_SOURCE=1'"]
        end

        cmake_args += ["-DIconv_INCLUDE_DIRS:PATH=/usr/include",
                       "-DIconv_LIBRARIES:PATH=/usr/lib/libiconv.dylib"]
      end

      system "cmake", "..", *cmake_args
      system "make", "VERBOSE=1", "install"
    end
  end

  def caveats; <<-EOS.undent
      The Neovim executable is called 'nvim'. To use your existing Vim
      configuration:
          ln -s ~/.vim ~/.config/nvim
          ln -s ~/.vimrc ~/.config/nvim/init.vim
      See ':help nvim' for more information on Neovim.

      When upgrading Neovim, check the following page for breaking changes:
          https://github.com/neovim/neovim/wiki/Following-HEAD

      If you want support for Python plugins such as YouCompleteMe, you need
      to install a Python module in addition to Neovim itself.

      Execute ':help nvim-python' in nvim or see the following page for more
      information:
          http://neovim.io/doc/user/nvim_python.html

      If you have any questions, have a look at:
          https://github.com/neovim/neovim/wiki/FAQ.
    EOS
  end

  test do
    (testpath/"test.txt").write("Hello World from Vim!!")
    system bin/"nvim", "--headless", "-i", "NONE", "-u", "NONE", "+s/Vim/Neovim/g", "+wq", "test.txt"
    assert_equal "Hello World from Neovim!!", File.read("test.txt").strip
  end
end
