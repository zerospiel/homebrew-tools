# typed: false
# frozen_string_literal: true

class Pidof < Formula
  desc "Display the PID number for a given process name(s)"
  homepage "https://github.com/zerospiel/pidof"
  url "https://github.com/zerospiel/pidof/archive/refs/tags/v0.1.2.tar.gz"
  sha256 "d1bf33456a6840510dbafd253d80b6d33984f86538cf5b1dba250f8287edda77"
  license "MIT"
  head "https://github.com/zerospiel/pidof.git", branch: "master"

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pidof -v")
  end
end
