# typed: false
# frozen_string_literal: true

# Written by the daemon release workflow. Don't edit: the next release replaces it.
class Handybox < Formula
  desc "Connect a Linux server to Handybox as your own box"
  homepage "https://handybox.cloud"
  version "0.2.0"
  license :cannot_represent

  PUBLIC_KEY = "RWSHAPpzFuRqT8HiJahooV0GMPeedA6SyRANSdPOHyMVAM/x6ZtEU9OT".freeze

  depends_on "minisign" => :build
  depends_on :linux

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/harshalranjhani/handybox-releases/releases/download/daemon-v0.2.0/handybox-daemon-linux-arm64"
      sha256 "b5ff30d9c58cbbfb8a8e196d8cd3db75b9c27688e5329e585700d045d8eeb3a8"
    else
      url "https://github.com/harshalranjhani/handybox-releases/releases/download/daemon-v0.2.0/handybox-daemon-linux-amd64"
      sha256 "e4d1762f1a39d6ce60c549b7c1b19015a3408882d281716418a0879b25a55037"
    end
  end

  resource "signature-amd64" do
    url "https://github.com/harshalranjhani/handybox-releases/releases/download/daemon-v0.2.0/handybox-daemon-linux-amd64.minisig"
    sha256 "21989c1b81735cce77b27fcf5c82f6fd3dd17a7cfdc9aa687405bbf2b68cca7a"
  end

  resource "signature-arm64" do
    url "https://github.com/harshalranjhani/handybox-releases/releases/download/daemon-v0.2.0/handybox-daemon-linux-arm64.minisig"
    sha256 "4397530d224250916617414fcf499e8aed9e634d4abd2718090c4a6efe764e3f"
  end

  resource "installer" do
    url "https://github.com/harshalranjhani/handybox-releases/releases/download/daemon-v0.2.0/install.sh"
    sha256 "cfbe9578d0ebd2d4a83c3094c0a469fed33ea7667b8d3be3ef9913179007cf81"
  end

  resource "installer-signature" do
    url "https://github.com/harshalranjhani/handybox-releases/releases/download/daemon-v0.2.0/install.sh.minisig"
    sha256 "10810b90f25910ccb919a7ee155d346e9142728d080e70e2657981393ba3a15f"
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
