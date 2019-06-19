class DealOrNoDeal

  ALL_CASE_VALUES = [
    1,
    100,
    500,
    1000,
    2500,
    5000,
    7500,
    10000,
    20000,
    30000,
    40000,
    50000,
    75000,
    100000,
    500000,
    1000000,
    2500000,
    5000000,
    7500000,
    10000000,
    20000000,
    30000000,
    40000000,
    50000000,
    75000000,
    100000000
  ]

  def initialize()
    # Shuffle up our cases for this game!
    @active_cases_for_this_game = ALL_CASE_VALUES.shuffle

    # Get the User's case
    @user_case = prompt_user_for_case

    # Now remove User's case from the this game's active cases while simultaneously capturing its value
    @user_case_value = remove_user_case_from_active_cases

    play_round(6)

  end

  def play_round( number_of_cases_to_remove )
    
  end

  def remove_user_case_from_active_cases
    @active_cases_for_this_game.slice!( @user_case - 1 )
  end

  def prompt_user_for_case
    valid_input = false

    while !valid_input
      puts "Please Select Your Case (1 - #{ALL_CASE_VALUES.length}):"
      user_input = gets
      valid_input = (1..ALL_CASE_VALUES.length).include?(user_input.to_i)
    end

    user_input.to_i
  end

end

DealOrNoDeal.new()