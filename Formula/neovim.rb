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
    url "https://github.com/libuv/libuv/archive/v1.2.0.tar.gz"
    sha256 "bebf424bb239867bbf609abad09a256cae7808c9d5cb346b779acd4b97a56693"
  end

  resource "msgpack" do
    url "https://github.com/msgpack/msgpack-c/archive/f6d0cd9a4ba46f4341014a199e3d352fad76b215.tar.gz"
    sha256 "988bb2bf86bb0f69816cbcbe2218285b94dbaa27e839f8b1ffdb0b934a7d726a"
  end

  resource "luajit" do
    url "http://luajit.org/download/LuaJIT-2.0.3.tar.gz"
    sha256 "55be6cb2d101ed38acca32c5b1f99ae345904b365b642203194c585d27bebd79"
  end

  resource "luarocks" do
    url "https://github.com/keplerproject/luarocks/archive/0587afbb5fe8ceb2f2eea16f486bd6183bf02f29.tar.gz"
    sha256 "c8ad50938fed66beba74a73621d14121d4a40b796e01c45238de4cdcb47d5e0b"
  end

  resource "libunibilium" do
    url "https://github.com/mauke/unibilium/archive/bb979ff6f66a18663e15d086dec6276561b86ee0.tar.gz"
    sha256 "bec06ea90128b46f28b91b8b52b861dede5f4ede0a92f05178b3c7bcec237dd1"
  end

  resource "libtermkey" do
    url "https://github.com/neovim/libtermkey/archive/8c0cb7108cc63218ea19aa898968eede19e19603.tar.gz"
    sha256 "21846369081e6c9a0b615f4b3889c4cb809321c5ccc6e6c1640eb138f1590072"
  end

  resource "libvterm" do
    url "https://github.com/neovim/libvterm/archive/1b745d29d45623aa8d22a7b9288c7b0e331c7088.tar.gz"
    sha256 "3fc75908256c0d158d6c2a32d39f34e86bfd26364f5404b7d9c03bb70cdc3611"
  end

  def install
    ENV.deparallelize

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
