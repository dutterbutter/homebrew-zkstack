class Zkstack < Formula
  desc     "ZKsync Stack CLI - spin up local or prod ZK Stack chains"
  homepage "https://github.com/matter-labs/zksync-era/tree/main/zkstack_cli"
  url      "https://github.com/dutterbutter/zkstack-cli/archive/refs/tags/v0.1.2.tar.gz"
  sha256   "…"
  license  "MIT"

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@3"
  end

  def install
    ENV["RUSTUP_TOOLCHAIN"] = "nightly-2024-09-01"
    # let Cargo see Homebrew's OpenSSL on Linux
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix if OS.linux?
    system "cargo", "install", *std_cargo_args(path: "crates/zkstack")
  end

  test do
    assert_match "zkstack", shell_output("#{bin}/zkstack --help")
  end
end
