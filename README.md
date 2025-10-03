# Budget AI

Budget AI is a personal finance management application designed to help users track their expenses, manage budgets, and gain insights into their spending habits. The app aims to provide a seamless and intuitive experience for financial planning.

Get app here: [Budget.AI](https://drive.google.com/file/d/1rFJu3gm04T12yxiZiwhqAUIT2pJ3j1FL/view?usp=drivesdk)

## Current Features

- **Budget Creation and Management**: Users can create and manage various budgets for different categories.
- **Transaction Tracking**: Record and categorize daily transactions to keep a detailed log of income and expenses.
- **Chatbot Integration**: An AI-powered chatbot assists users in creating budgets and provides financial insights through natural language interactions.
- **Themed UI**: The application features a consistent and visually appealing theme across its different sections, including custom dialogs and card designs.
- **Typing Animation**: A visual indicator shows when the chatbot is processing a request, enhancing user experience.

## Future Features

- **AI-Powered Automatic Transaction Input and voice**: Leverage AI to automatically input transactions based on notifications received from bank applications. This eliminates the need for manual entry and ensures accuracy.
- **Bank-Agnostic Transaction Import**: Implement a system that allows transaction import without requiring direct linking to bank accounts or relying on paid APIs. This ensures the app remains free, open-source, and avoids API fees.
- **Advanced Reporting and Analytics**: Provide more detailed reports and visual analytics to help users understand their financial patterns better.
- **Goal-Based Budgeting**: Allow users to set financial goals and track their progress towards achieving them.
- **Sync with google assistant**: Users can interact with the app directly through google assistant

## Setup Instructions

To get the Budget AI app up and running on your local machine, follow these steps:

1.  **Clone the repository**:
    ```bash
    git clone https://github.com/your-repo/budget-ai.git
    cd budget-ai
    ```

2.  **Install Flutter dependencies**:
    ```bash
    flutter pub get
    ```

3.  **Set up environment variables**:
    The chatbot feature relies on an API key. Create a `.env` file in the root of your project and add your API key:
    ```
    GEMINI_API_KEY=YOUR_API_KEY_HERE
    ```
    Replace `YOUR_API_KEY_HERE` with your actual Gemini API key. Ensure this file is not committed to version control.

4.  **Run the application**:
    ```bash
    flutter run
    ```

    For Android builds, if the chatbot feature is not working, please ensure your `.env` file is correctly set up and accessible in the release build. Make sure to include the `.env` file in your `pubspec.yaml` under the `assets` section:

    ```yaml
    flutter:
      assets:
        - .env
    ```

    After making changes, run `flutter clean` and `flutter pub get` before building the app again to ensure all assets are properly bundled.
