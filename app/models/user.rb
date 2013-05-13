class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :omniauthable, :omniauth_providers => [:facebook]
  
  def self.find_for_facebook_oauth(access_token, signed_in_resource=nil)
   data = access_token[:extra][:raw_info]
   unless user = User.find_by_email(data[:email])
     user = User.create!(:email => data[:email])
   end

   user
  end

  def self.new_with_session(params, session)
   super.tap do |user|
     if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]
       user.email = data["email"]
     end
   end
  end
  
  def migrate_user(old_user)
    logger.debug "Migrating old user #{old_user.id}"
    
    tasks = Task.where({:user_id => old_user.id})
    tasks.each do |task|
      logger.debug "-----------------copying task #{task.name}"
      task.user_id = self.id
      task.save!
    end
    
    old_user.destroy
  end
end
