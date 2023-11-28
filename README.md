# Reimbursement Calculation Script

## Overview

This Ruby script calculates the reimbursement amounts for a series of projects based on specified rules. Each project has a designated city cost type (high or low) and defined start and end dates.

## Thought Process and Approach

1. **Requirement Analysis**: Thorough review of project requirements.
2. **Data Structure Design**: Consideration of appropriate structures for project sets and rates.
3. **Rule Examination**: Manual exploration of rules to identify edge cases.
4. **Client Clarifications**: Sought clarifications on edge cases to refine understanding.
5. **Algorithm Development**: Brainstormed and strategized various algorithmic approaches.
6. **Iterative Development**: Started with simple implementation of some of the rules, gradually encompassing all rules.
7. **Code Refinement**: Refactored for optimization and readability.

Throughout the development process, I utilized ChatGPT as a collaborative tool. It served as a sounding board for ideas, helped troubleshoot errors, provided alternative problem-solving approaches, and offered refactoring advice. Importantly, I focused on understanding and internalizing any generated code rather than directly copying it, ensuring a general comprehension of its functionality and logic.

## Rules

- **Travel Days**: The first and last day of each project or a chronologically ordered set of projects are considered travel days.
- **Full Days**: Any day in the middle of a project or a set of projects.
- **Gaps**: Days on either side of a gap between projects are travel days.
- **Overlaps**: Overlapping days in projects are counted as full days. (assumption made here that this should ALWAYS be the case no matter if the day would have been a travel day otherwise)
- **City Costs**: Differentiates between high cost and low cost cities for reimbursement rates.
- **Unique Counting**: A day is only counted once, even if it appears in multiple projects.
- **Rate Selection**: For overlapping projects in different cities, the higher rate is used.

## Reimbursement Rates

- **Low Cost City**: Travel Day - $45/day, Full Day - $75/day
- **High Cost City**: Travel Day - $55/day, Full Day - $85/day

## Project Files

- `reimburse.rb`: Main script for reimbursement calculation.
- `test_reimburse.rb`: Test suite for the script.
- `test_project_sets.yml`: YAML file containing test project sets.
- `test_reimbursement_rates.yml`: YAML file with reimbursement rates.

### Prerequisites

Ensure Ruby is installed on your system. If not, download and install it from [Ruby's official site](https://www.ruby-lang.org/en/downloads/).

## Setup and Execution

```bash
git clone https://github.com/ca-collins/reimburse_me.git
```

```bash
cd reimburse_me
```

```bash
ruby test_reimburse.rb
```

Feel free to update the `test_project_sets.yml` and/or `test_reimbursement_rates.yml` as well as the expected values in `test_reimburse.rb` to test other scenarios.
