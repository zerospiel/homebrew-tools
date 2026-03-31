# Homebrew Tap

This repository is a custom Homebrew tap `zerospiel/tools`.

## Add a new Formula

Create `Formula/<name>.rb`.

Minimal example:

```ruby
class MyCli < Formula
  desc "Short description"
  homepage "https://github.com/<owner>/<repo>"
  url "https://github.com/<owner>/<repo>/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "<SHA256_OF_TARBALL>"
  license "MIT"

  def install
    bin.install "mycli"
  end

  test do
    system "#{bin}/mycli", "--help"
  end
end
```

Validation locally:

```bash
brew audit --strict Formula/<name>.rb
brew install --build-from-source ./Formula/<name>.rb
brew test <name>
```

## Add a new Cask

Create `Casks/<name>.rb`.

Minimal example:

```ruby
cask "my-app" do
  version "0.1.0"
  sha256 "<SHA256_OF_ARTIFACT>"

  url "https://github.com/<owner>/<repo>/releases/download/v#{version}/MyApp.zip"
  name "My App"
  desc "Short description"
  homepage "https://github.com/<owner>/<repo>"

  app "MyApp.app"
end
```

Validation locally:

```bash
brew audit --cask --strict Casks/<name>.rb
brew install --cask ./Casks/<name>.rb
```

## Install from this tap (user)

Tap this repository:

```bash
brew tap zerospiel/tools
```

Equivalent explicit URL form:

```bash
brew tap zerospiel/tools https://github.com/zerospiel/homebrew-tools.git
```

Install formula:

```bash
brew install zerospiel/tools/<formula_name>
```

Install cask:

```bash
brew install --cask zerospiel/tools/<cask_name>
```

Upgrade and uninstall:

```bash
brew update
brew upgrade zerospiel/tools/<formula_name>
brew uninstall zerospiel/tools/<formula_name>
```
