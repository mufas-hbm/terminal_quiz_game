from colorama import Fore, Back, Style


class Styler:
    @staticmethod
    def error_message(message):
        return f"\n{Fore.RED}{Style.BRIGHT}ERROR: {message}\n{Style.RESET_ALL}"

    @staticmethod
    def warning_message(message):
        return f"\n{Fore.YELLOW}{Style.BRIGHT}⚠️ WARNING: {message}\n{Style.RESET_ALL}"

    @staticmethod
    def title_message(message):
        return f"\n{Fore.CYAN}{Style.BRIGHT}{message.center(50, '=')}\n{Style.RESET_ALL}"

    @staticmethod
    def confirmation_message(message):
        return f"{Fore.BLUE}{Style.BRIGHT} {message}\n{Style.RESET_ALL}"

    @staticmethod
    def true_message(message):
        return f"{Fore.GREEN}{Style.BRIGHT}✓  {message}\n{Style.RESET_ALL}"

    @staticmethod
    def false_message(message):
        return f"{Fore.RED}{Style.BRIGHT}✗  {message}\n{Style.RESET_ALL}"

    @staticmethod
    def explanation_message(message):
        return f"{Fore.CYAN}{Style.DIM}\tExplanation: {message}\n{Style.RESET_ALL}"

    @staticmethod
    def choice_message(message):
        return f"{Back.RED}{Fore.BLACK}{Style.BRIGHT}Choice: {message}{Style.RESET_ALL}"

    @staticmethod
    def menu_message(options, title="Menu"):
        menu = f"{Fore.CYAN}{Style.BRIGHT}{title.center(50, '=')}{Style.RESET_ALL}\n"
        for number, option in enumerate(options, start=1):
            menu += f"{Fore.MAGENTA}[{number}] {option}{Style.RESET_ALL}\n"
        return menu
