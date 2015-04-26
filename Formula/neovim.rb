class Neovim < Formula
  homepage "http://neovim.org"
  head "https://github.com/neovim/neovim.git"

  depends_on "cmake" => :build
  depends_on "libtool" => :build
  depends_on "automake" => :build
  depends_on "autoconf" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext" => :build
  depends_on :python => :recommended if MacOS.version <= :snow_leopard

  resource "libuv" do
    url "https://github.com/libuv/libuv/archive/v1.4.2.tar.gz"
    sha256 "b9e424f69db0d1c3035c5f871cd9d7a3f4bace0a4db3e974bdbfa0cf95f6b741"
  end

  resource "msgpack" do
    url "https://github.com/msgpack/msgpack-c/archive/cpp-1.0.0.tar.gz"
    sha256 "afda64ca445203bb7092372b822bae8b2539fdcebbfc3f753f393628c2bcfe7d"
  end

  resource "luajit" do
    url "http://luajit.org/download/LuaJIT-2.0.3.tar.gz"
    sha256 "55be6cb2d101ed38acca32c5b1f99ae345904b365b642203194c585d27bebd79"
  end

  resource "luarocks" do
    url "https://github.com/keplerproject/luarocks/archive/0587afbb5fe8ceb2f2eea16f486bd6183bf02f29.tar.gz"
    sha256 "c8ad50938fed66beba74a73621d14121d4a40b796e01c45238de4cdcb47d5e0b"
  end

  resource "unibilium" do
    url "https://github.com/mauke/unibilium/archive/v1.1.2.tar.gz"
    sha256 "bdf3750b9e6ecdb30ba42dd0ef041c34222051495ff420c8c76d391f11e149e3"
  end

  resource "libtermkey" do
    url "https://github.com/neovim/libtermkey/archive/8c0cb7108cc63218ea19aa898968eede19e19603.tar.gz"
    sha256 "21846369081e6c9a0b615f4b3889c4cb809321c5ccc6e6c1640eb138f1590072"
  end

  resource "libvterm" do
    url "https://github.com/neovim/libvterm/archive/1b745d29d45623aa8d22a7b9288c7b0e331c7088.tar.gz"
    sha256 "3fc75908256c0d158d6c2a32d39f34e86bfd26364f5404b7d9c03bb70cdc3611"
  end

  resource "jemalloc" do
    url "https://github.com/jemalloc/jemalloc/archive/3.6.0.tar.gz"
    sha256 "68175f729423305dc8573cb093025a8db525e1956583c7c5924416a9abaaacb6"
  end

  def install
    ENV.deparallelize
    ENV["HOME"] = buildpath

    resources.each do |r|
      r.stage(buildpath/".deps/build/src/#{r.name}")
    end

    system "make", "CMAKE_BUILD_TYPE=RelWithDebInfo", "CMAKE_EXTRA_FLAGS=\"-DCMAKE_INSTALL_PREFIX:PATH=#{prefix}\"", "install"
  end

  def caveats; <<-EOS.undent
      If you want support for Python plugins such as YouCompleteMe, you need
      to install a Python module in addition to Neovim itself.

      See :h nvim-python-quickstart for more information.
    EOS
  end

  test do
    (testpath/"test.txt").write("Hello World from Vim!!")
    system bin/"nvim", "-u", "NONE", "+s/Vim/Neovim/g", "+wq", "test.txt"
    assert_equal "Hello World from Neovim!!", File.read("test.txt").strip
  end
end
