class Credstash < Formula
  desc "Password Manager Backup Tool - Secure CLI for backing up password vaults"
  homepage "git@github.com:harshalranjhani/credstash.git"
  url "git@github.com:harshalranjhani/credstash.git/archive/refs/tags/v0.0.1.tar.gz"
  sha256 "CALCULATE_MANUALLY"
  license "MIT"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/harshalranjhani/credstash/internal/version.Version=#{version}")
  end

  test do
    assert_match "credstash version #{version}", shell_output("#{bin}/credstash --version")
  end
end
