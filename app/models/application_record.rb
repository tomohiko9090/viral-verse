class ApplicationRecord < ActiveRecord::Base
  acts_as_paranoid
  primary_abstract_class
end
