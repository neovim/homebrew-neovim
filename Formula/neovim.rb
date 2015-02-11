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
    sha1 "38d1ba349fcfc1b221140523ba3d7cf3ea38c20b"
  end

  resource "msgpack" do
    url "https://github.com/msgpack/msgpack-c/archive/b4eba4ba090e8cd6d8332410e252296a62b7e56d.tar.gz"
    sha1 "768e60e3936cd0d0e4f1d58ca86a78eeb895931b"
  end

  resource "luajit" do
    url "http://luajit.org/download/LuaJIT-2.0.3.tar.gz"
    sha1 "2db39e7d1264918c2266b0436c313fbd12da4ceb"
  end

  resource "luarocks" do
    url "https://github.com/keplerproject/luarocks/archive/0587afbb5fe8ceb2f2eea16f486bd6183bf02f29.tar.gz"
    sha1 "61a894fd5d61987bf7e7f9c3e0c5de16ba4b68c4"
  end

  resource "libunibilium" do
    url "https://github.com/mauke/unibilium/archive/520abbc8b26910e2580619f669b5cc2c4ef7f864.tar.gz"
    sha1 "c546e5e8861380f5c109a256f25c93419e4076bf"
  end

  resource "libtermkey" do
    url "https://github.com/neovim/libtermkey/archive/8c0cb7108cc63218ea19aa898968eede19e19603.tar.gz"
    sha1 "54e8b6914dab10d4467d2a563f80053a99849fcb"
  end

  def install
    ENV["GIT_DIR"] = cached_download/".git" if build.head?
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
