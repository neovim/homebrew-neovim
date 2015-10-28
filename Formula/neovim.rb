class Neovim < Formula
  desc "Ambitious Vim-fork focused on extensibility and agility"
  homepage "http://neovim.io"
  head "https://github.com/neovim/neovim.git"

  depends_on "cmake" => :build
  depends_on "libtool" => :build
  depends_on "automake" => :build
  depends_on "autoconf" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext" => :build
  depends_on :python => :recommended if MacOS.version <= :snow_leopard

  resource "libuv" do
    url "https://github.com/libuv/libuv/archive/v1.7.2.tar.gz"
    sha256 "2f27cc888192e4ee6ada8477f9897bea648de5b04207c984271efa91295c0fc8"
  end

  resource "msgpack" do
    url "https://github.com/msgpack/msgpack-c/archive/cpp-1.0.0.tar.gz"
    sha256 "afda64ca445203bb7092372b822bae8b2539fdcebbfc3f753f393628c2bcfe7d"
  end

  resource "luajit" do
    url "http://luajit.org/download/LuaJIT-2.0.4.tar.gz"
    sha256 "620fa4eb12375021bef6e4f237cbd2dd5d49e56beb414bee052c746beef1807d"
  end

  resource "luarocks" do
    url "https://github.com/keplerproject/luarocks/archive/0587afbb5fe8ceb2f2eea16f486bd6183bf02f29.tar.gz"
    sha256 "c8ad50938fed66beba74a73621d14121d4a40b796e01c45238de4cdcb47d5e0b"
  end

  resource "unibilium" do
    url "https://github.com/mauke/unibilium/archive/v1.1.4.tar.gz"
    sha256 "8b8948266eb370eef8100f401d530451d627a17c068a3f85cd5d62a57517aaa7"
  end

  resource "libtermkey" do
    url "http://www.leonerd.org.uk/code/libtermkey/libtermkey-0.18.tar.gz"
    sha256 "239746de41c845af52bb3c14055558f743292dd6c24ac26c2d6567a5a6093926"
  end

  resource "libvterm" do
    url "https://github.com/neovim/libvterm/archive/1b745d29d45623aa8d22a7b9288c7b0e331c7088.tar.gz"
    sha256 "3fc75908256c0d158d6c2a32d39f34e86bfd26364f5404b7d9c03bb70cdc3611"
  end

  resource "jemalloc" do
    url "https://github.com/jemalloc/jemalloc/releases/download/3.6.0/jemalloc-3.6.0.tar.bz2"
    sha256 "e16c2159dd3c81ca2dc3b5c9ef0d43e1f2f45b04548f42db12e7c12d7bdf84fe"
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
             "-DUSE_EXISTING_SRC_DIR=ON", *std_cmake_args
      system "make", "VERBOSE=1"
    end

    mkdir "build" do
      ohai "Building Neovim."
      cmake_args = std_cmake_args + ["-DDEPS_PREFIX=../deps-build/usr",
                                     "-DCMAKE_BUILD_TYPE=RelWithDebInfo",]
      system "cmake", "..", *cmake_args
      system "make", "VERBOSE=1", "install"
    end
  end

  def caveats; <<-EOS.undent
      The Neovim executable is called 'nvim'. If you are already familiar
      with Vim, see ':help nvim-from-vim' to get started.

      When upgrading Neovim, check the following page for breaking changes:
          https://github.com/neovim/neovim/wiki/Following-HEAD

      If you want support for Python plugins such as YouCompleteMe, you need
      to install a Python module in addition to Neovim itself.
      See ':help nvim-python' for more information.
    EOS
  end

  test do
    (testpath/"test.txt").write("Hello World from Vim!!")
    system bin/"nvim", "--headless", "-i", "NONE", "-u", "NONE", "+s/Vim/Neovim/g", "+wq", "test.txt"
    assert_equal "Hello World from Neovim!!", File.read("test.txt").strip
  end
end
