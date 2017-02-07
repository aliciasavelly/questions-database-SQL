require 'sqlite3'
require_relative 'questionsdbconnection'
require_relative 'user'

class QuestionFollow
  attr_accessor :id, :user_id, :question_id

  def self.all
    data = QuestionsDBConnection.instance.execute("SELECT * FROM question_follows")
    data.map{|datum| QuestionFollow.new(datum) }
  end

  def initialize(options)
    @id = options['id']
    @user_id = options['user_id']
    @question_id = options['question_id']
  end

  def self.find_by_id(id)
    question_follow = QuestionsDBConnection.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        question_follows
      WHERE
        id = ?
    SQL
    return nil if question_follow.empty?

    QuestionFollow.new(question_follow.first)
  end

  def self.followers_for_question_id(question_id)
    users = QuestionsDBConnection.instance.execute(<<-SQL, question_id)
      SELECT
        users.*
      FROM
        question_follows
      JOIN
        users ON question_follows.user_id = users.id
      WHERE
        question_follows.question_id = ?
    SQL
    return nil if users.empty?

    users.map { |user| User.new(user) }
  end

  def self.followed_questions_for_user_id(user_id)
    questions = QuestionsDBConnection.instance.execute(<<-SQL, user_id)
      SELECT
        questions.*
      FROM
        question_follows
      JOIN
        questions ON question_follows.user_id = questions.user_id
      WHERE
        question_follows.user_id = ?
    SQL
    return nil if questions.empty?

    questions.map { |option| Question.new(option) }
  end

  def self.most_followed_questions(n)
    questions = QuestionsDBConnection.instance.execute(<<-SQL, n)
      SELECT
        questions.*, COUNT(question_follows.question_id)
      FROM
        question_follows
      JOIN
        questions ON question_follows.question_id = questions.id
      ORDER BY
        question_follows.question_id DESC
      -- HAVING
      --   COUNT(question_follows.question_id)
      LIMIT
        ?
    SQL

    return nil if questions.empty?

    questions.map { |option| Question.new(option) }
  end

end
