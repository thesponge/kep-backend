require 'ffaker'

namespace :db do
  task populate: :environment do
    Assignment.destroy_all

    10.times do
     Assignment.create(
        title: FFaker::HipsterIpsum.words(10).join(' '),
        description: FFaker::HipsterIpsum.words(100).join(' '),
        travel: FFaker::Boolean.maybe
      )

    end


    10.times do
      Resource.create(
        title: FFaker::HipsterIpsum.words(10).join(' '),
        description: FFaker::HipsterIpsum.words(100).join(' '),
        travel: FFaker::Boolean.maybe
      )
    end
  end
end
