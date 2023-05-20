# Project Description

This is a template project designed to expedite the setup process for side projects. It aims to minimize boilerplate code and infrastructure concerns, allowing developers to focus on business logic.

## Requirements

- Raspberry Pi with dotnet >= 7 and Docker version >= 2.18.0 installed.

## Configuration

1. Create a file named `.env` in the root directory of the project.
2. Inside the `.env` file, add the following line: `DatabasePassword="<DatabasePasswordOfYourChoice>"`. Replace `<DatabasePasswordOfYourChoice>` with the desired password for your database.

## Installation

1. Make the `setup.sh` script executable by running the following command: `chmod +x setup.sh`.
2. Execute the `setup.sh` script and wait for the console output to display "Migration done".
3. Stop the container by pressing the CTRL+C key combination.

## Building

- To run the application, make the `run.sh` script executable by running the following command: `chmod +x run.sh`.
- Execute the `run.sh` script in a shell by running `./run.sh`.
- On a macOS or PC, navigate to `https://localhost` in a browser. If running on a Raspberry Pi in your local network, replace `localhost` with the IP address of your Raspberry Pi.

## Troubleshooting

- If you encounter any issues or errors during setup or execution, please refer to the project's issue tracker or contact the project maintainers for assistance.

## License

- This project is licensed under the MIT License. See the LICENSE.md file for more details.
