# typed: false
# frozen_string_literal: true

# Written by the daemon release workflow. Don't edit: the next release replaces it.
class Handybox < Formula
  desc "Connect a Linux server to Handybox as your own box"
  homepage "https://handybox.cloud"
  version "0.1.1"
  license :cannot_represent

  PUBLIC_KEY = "RWSHAPpzFuRqT8HiJahooV0GMPeedA6SyRANSdPOHyMVAM/x6ZtEU9OT".freeze

  depends_on "minisign" => :build
  depends_on :linux

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/harshalranjhani/handybox-releases/releases/download/daemon-v0.1.1/handybox-daemon-linux-arm64"
      sha256 "5073013bd9f9a07c18162bfa62d28ad3dd3922d94da7a8680f7ab723e0776636"
    else
      url "https://github.com/harshalranjhani/handybox-releases/releases/download/daemon-v0.1.1/handybox-daemon-linux-amd64"
      sha256 "77e3e643d4fa4a767174717e6e3553c86018c848e7276327b17d3ac3a469cdcf"
    end
  end

  resource "signature-amd64" do
    url "https://github.com/harshalranjhani/handybox-releases/releases/download/daemon-v0.1.1/handybox-daemon-linux-amd64.minisig"
    sha256 "ed2c31d39d43565f46cc1df42ff073f6a9da294b092a6d2c4718a5b61a83a3ad"
  end

  resource "signature-arm64" do
    url "https://github.com/harshalranjhani/handybox-releases/releases/download/daemon-v0.1.1/handybox-daemon-linux-arm64.minisig"
    sha256 "067dbaf2aca470e199e538ccf4d52cda583241f3b8237696f404d5b1ae857497"
  end

  resource "installer" do
    url "https://github.com/harshalranjhani/handybox-releases/releases/download/daemon-v0.1.1/install.sh"
    sha256 "34a7c262b16f59a0dc7f79135691548a9c73dace1ce15600e324ed8413247b22"
  end

  resource "installer-signature" do
    url "https://github.com/harshalranjhani/handybox-releases/releases/download/daemon-v0.1.1/install.sh.minisig"
    sha256 "9dc4ab9aedee1e7e85289acd1ecb50c61e2ec503b0cff5ce8a88906ff59f2d69"
  end

  def install
    arch = Hardware::CPU.arm? ? "arm64" : "amd64"
    binary = "handybox-daemon-linux-#{arch}"
    resource("signature-#{arch}").stage { buildpath.install "#{binary}.minisig" }
    resource("installer").stage { buildpath.install "install.sh" }
    resource("installer-signature").stage { buildpath.install "install.sh.minisig" }
    minisign = Formula["minisign"].opt_bin/"minisign"
    system minisign, "-V", "-q", "-P", PUBLIC_KEY, "-m", binary, "-x", "#{binary}.minisig"
    system minisign, "-V", "-q", "-P", PUBLIC_KEY, "-m", "install.sh", "-x", "install.sh.minisig"
    chmod 0755, [binary, "install.sh"]
    inreplace "install.sh", /^BUNDLED_BINARY=.*$/, "BUNDLED_BINARY='#{opt_libexec}/handybox-daemon'"
    libexec.install binary => "handybox-daemon"
    bin.install "install.sh" => "handybox"
  end

  test do
    assert_match "handybox #{version}", shell_output("#{bin}/handybox --version")
  end
end
