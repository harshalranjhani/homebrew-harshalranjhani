# typed: false
# frozen_string_literal: true

# This file was generated by GoReleaser. DO NOT EDIT.
class Genie < Formula
  desc ""
  homepage "https://genie.harshalranjhani.in"
  version "2.3.1"

  on_macos do
    url "https://github.com/harshalranjhani/genie/releases/download/v2.3.1/genie_Darwin_all.tar.gz"
    sha256 "92a28ae959187c9c60ffefc08351850938443f8e4d6679160b8cd91862a68162"

    def install
      bin.install "genie"
    end
  end

  on_linux do
    on_intel do
      if Hardware::CPU.is_64_bit?
        url "https://github.com/harshalranjhani/genie/releases/download/v2.3.1/genie_Linux_x86_64.tar.gz"
        sha256 "32be4e9fec9a6a553fcf4969728b2bd6bb6eca76c7b217598b14dc73a1483764"

        def install
          bin.install "genie"
        end
      end
    end
    on_arm do
      if Hardware::CPU.is_64_bit?
        url "https://github.com/harshalranjhani/genie/releases/download/v2.3.1/genie_Linux_arm64.tar.gz"
        sha256 "62ba6e7c5324dc1671ae74a22d842996cbefb271f0d06dfee9baa03cd205e761"

        def install
          bin.install "genie"
        end
      end
    end
  end
end
