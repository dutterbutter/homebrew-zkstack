class Zkstack < Formula
  desc "CLI to spin up zkSync Era chains with zkStack"
  homepage "https://github.com/matter-labs/zksync-era/tree/main/zkstack_cli"
  url "https://github.com/dutterbutter/zkstack-cli/archive/refs/tags/v0.1.2.tar.gz"
  sha256 "30abf5b920d69b516ef42898ba285f03b77749b80b9d832bd877644d7d99557e"
  license "MIT"
  head "https://github.com/dutterbutter/zkstack-cli.git", branch: "main"

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@3"
  end

  def install
    # The project currently needs a specific nightly compiler.
    ENV["RUSTUP_TOOLCHAIN"] = "nightly-2024-09-01"

    # Help Cargo discover Homebrew-provided OpenSSL on Linux.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix if OS.linux?

    system "cargo", "install", *std_cargo_args(path: "crates/zkstack")

    # ─── shell completions ──────────────────────────────────────────────────────
    # Pre-generated completion scripts live under crates/zkstack/completion/
    completion_dir = buildpath/"crates/zkstack/completion"
    bash_completion.install completion_dir/"zkstack.bash" => "zkstack"
    zsh_completion.install  completion_dir/"_zkstack"
    fish_completion.install completion_dir/"zkstack.fish"
  end

  test do
    # --version should print the tag version
    assert_match version.to_s, shell_output("#{bin}/zkstack --version")

    # Basic help text sanity-check
    assert_match "USAGE", shell_output("#{bin}/zkstack --help")

    # Bash completion script loads and registers a completion function
    assert_match "-F _zkstack",
                 shell_output("bash -c 'source #{bash_completion}/zkstack && complete -p zkstack'")
  end
end
