require './item'
require './genre/genre'
require './label'
require './author/author'
require './author/create_author'

class Game < Item
  attr_reader :last_played_at, :multiplayer

  def initialize(publish_date, multiplayer, last_played_at, id = Random.rand(1..1000), archived: false)
    super(publish_date, id, archived: archived)
    @multiplayer = multiplayer
    @last_played_at = last_played_at # #date object: date_format: YYYY-mm-dd
  end

  def get_genre(_genres)
    puts "what's the genre of the game?"
    answer = gets.chomp
    Genre.new(answer)
  end

  def obtain_label()
    puts 'what is the title of the game?'
    title = gets.chomp

    puts 'what is the color of the game'
    color = gets.chomp

    Label.new(nil, title, color)
  end

  # rubocop:disable Metrics/MethodLength
  def obtain_author()
    puts 'Which author is this game for?'

    if ctx.author_list.empty?
      puts 'There are no authors to select from'
    else
      puts 'Select an author choosing the number:'
      loop do
        ctx.author_list.each_with_index do |author, index|
          puts "#{index + 1}. #{author.first_name} #{author.last_name}\n"
        end

        choice = gets.chomp.to_i
        return ctx.author_list[choice - 1] if choice.positive? && choice <= ctx.author_list.length

        puts 'Invalid input: please enter a number from the list.'
        puts 'Do you want to create a new author? [y/n]'
        case gets.chomp.downcase
        when 'y'
          break
        when 'n'
          next
        end
      end
    end
    CreateAuthor.new.return_author
  end
  # rubocop:enable Metrics/MethodLength

  private

  def can_be_archived?
    return false if @last_played_at.nil?

    @last_played_at.next_year(2) > Date.today && super
  end
end
