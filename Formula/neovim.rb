require "formula"

class Neovim < Formula
  homepage "http://neovim.org"
  head "https://github.com/neovim/neovim.git"

  depends_on "cmake" => :build
  depends_on "libtool" => :build
  depends_on "automake" => :build
  depends_on "autoconf" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext" => :build

  resource "libuv" do
    url "https://github.com/libuv/libuv/archive/v1.0.1.tar.gz"
    sha1 "be4edcca18a518153b5e249a17621f2674d7654d"
  end

  resource "msgpack" do
    url "https://github.com/msgpack/msgpack-c/archive/ecf4b09acd29746829b6a02939db91dfdec635b4.tar.gz"
    sha1 "c160ff99f20d9d0a25bea0a57f4452f1c9bde370"
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
    url "https://github.com/mauke/unibilium/archive/v1.1.1.tar.gz"
    sha1 "582cbac75989d70e70953fa826cb5457cbfacc10"
  end

  resource "libtermkey" do
    url "https://github.com/neovim/libtermkey/archive/neovim.tar.gz"
    sha1 "a309038a2297fe4905f03a8807723a9aa07c272a"
  end

  resource "libtickit" do
    url "https://github.com/neovim/libtickit/archive/neovim.tar.gz"
    sha1 "49e609de29c3bdc3b40d2ade76e69fde6e0d74bc"
  end

  def install
    ENV["GIT_DIR"] = cached_download/".git" if build.head?
    ENV.deparallelize

    resources.each do |r|
      r.stage(target=buildpath/".deps/build/src/#{r.name}")
    end

    system "make", "CMAKE_BUILD_TYPE=RelWithDebInfo", "CMAKE_EXTRA_FLAGS=\"-DCMAKE_INSTALL_PREFIX:PATH=#{prefix}\"", "install"
  end

  test do
    (testpath/"test.txt").write("Hello World from Vim!!")
    system bin/"nvim", "-u", "NONE", "+s/Vim/Neovim/g", "+wq", "test.txt"
    assert_equal "Hello World from Neovim!!", File.read("test.txt").strip
  end
end
