# 👾 SPACE INVADERS DETECTOR 👾

## Installation

```shell
   bundle install
```

## 🔍 Detecting Invaders

### Running the Scanner

To detect invaders in a radar sample, you can run the `scan` command with a radar sample file as an argument:

```shell
ruby space_invaders_scanner.rb scan -f path/to/radar_sample.txt
```

### Options

- `-f`, `--file FILE` - specifies the radar sample file to scan (default: `data/radar_sample.txt`)

- `--show-rotations` - to see all rotations of the invader patterns

### Example Usage

- to scan a custom radar sample:

```shell
    ruby space_invaders_scanner.rb scan -f data/sample_radar.txt
```

- if no file is provided, the tool will automatically use the default radar sample (`data/radar_sample.txt`):

```shell
    ruby space_invaders_scanner.rb scan
```

By default, only the base invader patterns are displayed. If you want to see all rotations of the invader patterns, use the `--show-rotations` flag:

```shell
    ruby space_invaders_scanner.rb scan --show-rotations
```

---

## ℹ️ Help & Usage

To view all available commands and options for the tool, use the `--help` flag:

```shell
    ruby space_invaders_scanner.rb --help
```

### ✅ Running Tests

Execute the following command to run the tests:

```
    shell
    bundle exec rspec spec
```
