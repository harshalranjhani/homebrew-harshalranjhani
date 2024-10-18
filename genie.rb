# typed: false
# frozen_string_literal: true

# This file was generated by GoReleaser. DO NOT EDIT.
class Genie < Formula
  desc ""
  homepage "https://genie.harshalranjhani.in"
  version "2.7.3"

  on_macos do
    url "https://github.com/harshalranjhani/genie/releases/download/v2.7.3/genie_Darwin_all.tar.gz"
    sha256 "7863b8cb6308321e7ee111186736071000aac83f87a15d8bbdc673f69e825994"

    def install
      bin.install "genie"
    end
  end

  on_linux do
    on_intel do
      if Hardware::CPU.is_64_bit?
        url "https://github.com/harshalranjhani/genie/releases/download/v2.7.3/genie_Linux_x86_64.tar.gz"
        sha256 "821b4152d1c5443b23ca5b0f045173e9ee121e1f2459e3a7b3fb09889b7358e0"

        def install
          bin.install "genie"
        end
      end
    end
    on_arm do
      if Hardware::CPU.is_64_bit?
        url "https://github.com/harshalranjhani/genie/releases/download/v2.7.3/genie_Linux_arm64.tar.gz"
        sha256 "22e05b77c33bb42147b640acca284645373bb2270bed12521f69b1af2b839828"

        def install
          bin.install "genie"
        end
      end
    end
  end
end
