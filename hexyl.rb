class Hexyl < Formula
  desc "A command-line hex viewer "
  homepage "https://github.com/sharkdp/hexyl"
  url "https://github.com/sharkdp/hexyl/archive/v0.3.0.tar.gz"
  sha256 "7a6b8c6058fa887105dcd5f85b2808b2e0e7557f13b28d6fe802ce5609ff473e"
  head "https://github.com/sharkdp/hexyl.git"

  bottle do
    sha256 "b401bbba34d24a248b9a91d43caa383130ed2dd1b50f15cb2329fc0b1ca3e72a" => :mojave
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--root", prefix, "--path", "."
  end
end
