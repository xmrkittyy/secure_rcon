# Enchanced rcon security for fivem

## Overview

secure_rcon enhances FiveM RCON security by enforcing strong password policies, IP whitelisting, and tracking failed login attempts.

## Features

- **Strong Password Policies**: Enforces minimum length and complexity.
- **IP Whitelisting**: Restricts RCON access to specified IPs.
- **Failed Login Tracking**: Limits failed attempts, blocking IPs after multiple failures.

## Installation

1. **Download**: Clone or download this repository.
2. **Add to Server**: Place the folder in your FiveM `resources` directory.
3. **Update `server.cfg`**: Add `ensure secure_rcon`.

## Configuration

Edit `server.lua` to customize settings:

- **Password Complexity**:
  ```lua
  local minPasswordLength = 8
  local complexityRegex = "%w+%W+"
  ```
- **IP Whitelist**:
  ```lua
  local whitelist = { "192.168.1.1", "10.0.0.1" }
  ```
- **Failed Login Settings**:
  ```lua
  local failedLoginThreshold = 2
  local blockDuration = 300
  ```

## Usage

secure_rcon will:
- Allow RCON commands only from whitelisted IPs.
- Enforce password complexity requirements.
- Block IPs after exceeding failed login attempts.
