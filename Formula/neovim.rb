class Neovim < Formula
  desc "Ambitious Vim-fork focused on extensibility and agility"
  homepage "https://neovim.io"
  url "https://github.com/neovim/neovim/archive/v0.1.1.tar.gz"
  sha256 "f39bcab23457c66ce0d67dcf8029743703f860413db0070f75d4f0ffad27c6c1"

  head do
    url "https://github.com/neovim/neovim.git"
  end

  depends_on "cmake" => :build
  depends_on "libtool" => :build
  depends_on "automake" => :build
  depends_on "autoconf" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext" => :build

  depends_on "homebrew/headonly/libvterm"
  depends_on "jemalloc"
  depends_on "libtermkey"
  depends_on "libuv"
  depends_on "luajit"
  depends_on "luarocks"
  depends_on "msgpack"
  depends_on "unibilium"
  depends_on :python => :recommended if MacOS.version <= :snow_leopard

  depends_on "lpeg" => :lua
  depends_on "lua-messagepack" => :lua
  depends_on "luabitop" => :lua

  def install
    ENV.deparallelize
    ENV["HOME"] = buildpath

    mkdir "build" do
      build_type = build.head? ? "Dev" : "RelWithDebInfo"
      cmake_args = std_cmake_args + ["-DCMAKE_BUILD_TYPE=#{build_type}"]
      if OS.mac?
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
