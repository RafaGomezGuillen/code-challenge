# frozen_string_literal: true

module CLIHelpers
  # Clear the console screen
  def clear_console
    system('clear') || system('cls')
  end

  # Pause and wait for user input before clearing the screen
  def pause_and_clear
    puts "\nPress ENTER to return to menu..."
    gets
  end
end
