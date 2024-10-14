# typed: false
# frozen_string_literal: true

# This file was generated by GoReleaser. DO NOT EDIT.
class Genie < Formula
  desc ""
  homepage "https://genie.harshalranjhani.in"
  version "2.7.1"

  on_macos do
    url "https://github.com/harshalranjhani/genie/releases/download/v2.7.1/genie_Darwin_all.tar.gz"
    sha256 "448ae9a369ea9543d80867617ff096ca26287e56490ab2576df064fc2865676d"

    def install
      bin.install "genie"
    end
  end

  on_linux do
    on_intel do
      if Hardware::CPU.is_64_bit?
        url "https://github.com/harshalranjhani/genie/releases/download/v2.7.1/genie_Linux_x86_64.tar.gz"
        sha256 "9a22fdd6db5a3ad2f051bbef779b1c3d7c111a821a095b1741751cc9af3e4461"

        def install
          bin.install "genie"
        end
      end
    end
    on_arm do
      if Hardware::CPU.is_64_bit?
        url "https://github.com/harshalranjhani/genie/releases/download/v2.7.1/genie_Linux_arm64.tar.gz"
        sha256 "872206025aa7d5b20fec896212c4d94e9bec348c85d4a475814a73c8b054e7c8"

        def install
          bin.install "genie"
        end
      end
    end
  end
end
