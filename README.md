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

- `--match-threshold <THRESHOLD>` - to specify a custom match threshold (0.8, 0.9, 1.0)

If no threshold is specified, the default value of 0.8 is used.
1.0 is for strict matching.

### Example Usage

- to scan a custom radar sample:

```shell
    ruby space_invaders_scanner.rb scan -f data/sample_radar.txt
```

- if no file is provided, the tool will automatically use the default radar sample (`data/radar_sample.txt`):

```shell
    ruby space_invaders_scanner.rb scan
```

By default, only the base invader patterns are included. If you want to match invaders by all rotations of the invader patterns, use the `--include-rotations` flag:

```shell
    ruby space_invaders_scanner.rb scan --include-rotations
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

#### Future Improvements

In the next steps, I plan to optimize the matcher for better performance and scalability. Potential improvements include:

- Matcher Optimization: Implementing caching mechanisms to reduce redundant calculations and speed up the matching process.
- Algorithm selection: Tailoring the matching algorithm based on the size and complexity of the dataset, to ensure efficient processing under various conditions.
- Edge case handling: Addressing additional edge cases, such as mirrored invaders or other patterns that might be reflected, ensuring that the matcher is robust and adaptable to different scenarios.
