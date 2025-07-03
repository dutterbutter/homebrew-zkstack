# Formula/zkstack.rb
class Zkstack < Formula
  desc     "ZKsync Stack CLI - spin up local or prod zkStack chains"
  homepage "https://github.com/matter-labs/zksync-era/tree/main/zkstack_cli"
  url      "https://github.com/dutterbutter/zkstack-cli/archive/refs/tags/v0.1.2.tar.gz"
  sha256   "30abf5b920d69b516ef42898ba285f03b77749b80b9d832bd877644d7d99557e"
  license  "MIT"

  depends_on "rust" => :build

  livecheck do
    url :stable
    regex(/^v?(\d+\.\d+\.\d+)$/i)
  end

  def install
    ENV["RUSTUP_TOOLCHAIN"] = "nightly-2024-09-01"
    system "cargo", "install", *std_cargo_args(path: "crates/zkstack")
  end

  test do
    assert_match "zkstack", shell_output("#{bin}/zkstack --help")
  end
end
