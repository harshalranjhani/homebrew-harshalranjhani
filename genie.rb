# typed: false
# frozen_string_literal: true

# This file was generated by GoReleaser. DO NOT EDIT.
class Genie < Formula
  desc ""
  homepage "https://genie.harshalranjhani.in"
  version "2.0.1"

  on_macos do
    url "https://github.com/harshalranjhani/genie/releases/download/v2.0.1/genie_Darwin_all.tar.gz"
    sha256 "db19b0e37a530867f488b6d2c3014a8f9f9e4ad514b0d21293284fc033c221ba"

    def install
      bin.install "genie"
    end
  end

  on_linux do
    on_intel do
      if Hardware::CPU.is_64_bit?
        url "https://github.com/harshalranjhani/genie/releases/download/v2.0.1/genie_Linux_x86_64.tar.gz"
        sha256 "8d0027d56834fccf705edc38c4fea487f014b3d2d5c927d73838e02db677c493"

        def install
          bin.install "genie"
        end
      end
    end
    on_arm do
      if Hardware::CPU.is_64_bit?
        url "https://github.com/harshalranjhani/genie/releases/download/v2.0.1/genie_Linux_arm64.tar.gz"
        sha256 "ded977de3759e5060c0dc4c88c7f323fce794fe7e2139b28ea28480ed2256141"

        def install
          bin.install "genie"
        end
      end
    end
  end
end
