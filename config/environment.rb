require 'bundler'
Bundler.require

require_all 'lib'
require 'sqlite3'
require 'json'

# DB = {:conn => SQLite3::Database.new('db/training_data.db')}
# DB[:conn].execute("DROP TABLE IF EXISTS training_data_states")
# DB[:conn].execute("DROP TABLE IF EXISTS training_data_actions")

# create_states_table = <<-SQL
# 	CREATE TABLE IF NOT EXISTS training_data_states (
# 		id INTEGER PRIMARY KEY,
# 		state_key TEXT NOT NULL UNIQUE
# 	)
# SQL

# create_actions_table = <<-SQL
# 	CREATE TABLE IF NOT EXISTS training_data_actions (
# 		id INTEGER PRIMARY KEY,
# 		action_key TEXT NOT NULL,
# 		q_value INTEGER,
# 		state_key INTEGER NOT NULL REFERENCES training_data_states(state_key)
# 	)
# SQL

# DB[:conn].execute(create_states_table)
# DB[:conn].execute(create_actions_table)

# DB[:conn].results_as_hash = true

