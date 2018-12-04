class RegisterVoter
  def self.call(email, secret={})
    new(email, secret).call
  end

  def call
    printf "Persistence--\n"
    Rails.logger.debug(@voter.persisted?)
    printf "\nValid Secret"
    Rails.logger.debug(valid_secret?)
    printf " After"
    return nil unless (@voter.persisted? && valid_secret?)
    printf "still here ?"
    @voter.generate_verification_token!
    VoterMailer.voter_verification_email(@voter).deliver
    # VoterMailer.voter_verification_email(@voter).deliver_now
    @voter
  end

  private

  def initialize(email, secret)
    @voter = Voter.find_or_create_by(email: email)
    @secret = VoterSecret.find_or_create_by(data: hstore(secret)) #VoterSecret.find_by("data = :data", data: hstore(secret))
  end

  def hstore(hash)
    hash.to_s[1...-1]
  end

  def valid_secret?
    return true if VoterSecret.list_of_secrets.empty?
    !@secret.nil?
  end
end