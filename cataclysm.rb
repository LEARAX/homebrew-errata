class Cataclysm < Formula
  desc "Fork/variant of Cataclysm Roguelike"
  homepage "https://github.com/CleverRaven/Cataclysm-DDA"
  url "https://github.com/CleverRaven/Cataclysm-DDA/archive/0.D.tar.gz"
  version "0.D"
  sha256 "6cc97b3e1e466b8585e8433a6d6010931e9a073f6ec060113161b38052d82882"
  revision 1
  head "https://github.com/CleverRaven/Cataclysm-DDA.git"

  option "with-tiles", "Enable tileset support"

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "lua"

  if build.with? "tiles"
    depends_on "sdl2"
    depends_on "sdl2_image"
    depends_on "sdl2_mixer"
    depends_on "sdl2_ttf"
    depends_on "libogg"
    depends_on "libvorbis"
  end

  needs :cxx11

  def install
    ENV.cxx11

    args = %W[
      NATIVE=osx
      RELEASE=1
      OSX_MIN=#{MacOS.version}
      LUA=1
      USE_HOME_DIR=1
    ]

    args << "TILES=1" if build.with? "tiles"
    args << "SOUND=1" if build.with? "tiles"
    args << "CLANG=1" if ENV.compiler == :clang

    system "make", *args

    if build.with? "tiles"
      libexec.install "cataclysm-tiles", "data", "gfx", "lua"
    else
      libexec.install "cataclysm", "data", "lua"
    end

    inreplace "cataclysm-launcher" do |s|
      s.change_make_var! "DIR", libexec
    end
    bin.install "cataclysm-launcher" => "cataclysm"
  end

  test do
    # make user config directory
    user_config_dir = testpath/"Library/Application Support/Cataclysm/"
    user_config_dir.mkpath

    # run cataclysm for 5 seconds
    game = fork do
      system bin/"cataclysm"
    end

    sleep 5
    Process.kill("HUP", game)

    assert_predicate user_config_dir/"config",
                     :exist?, "User config directory should exist"
    assert_predicate user_config_dir/"templates",
                     :exist?, "User template directory should exist"
    assert_predicate user_config_dir/"save",
                     :exist?, "User save directory should exist"
  end
end
