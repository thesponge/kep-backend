class ManualMatchMailer < ApplicationMailer

  def match_uu(nominee, second_nominee, matcher)
    @nominee = nominee
    @second_nominee = second_nominee
    @matcher = matcher
    #See routes for profiles
    @url_matcher  = 'http://kep.thesponge.eu/apps/match/dashboard/' + what + "/" + id.to_s
    @url_nominee = 'http://kep.thesponge.eu/apps/match/dashboard/' + what + "/" + id.to_s
    mail(to: @nominee.email, subject: 'Shared interests')
    #???Ask Stefan to write the fkn emails
  end

  def match_ur_nominee(nominee, resource, matcher)
    @nominee = nominee
    @resource = resource
    @matcher = matcher
    @url_resource = 'http://kep.thesponge.eu/resources/' + resource.id.to_s
    @url_matcher  = 'http://kep.thesponge.eu/apps/match/dashboard/' + what + "/" + id.to_s
    mail(to: @nominee.email, subject: 'A resource has been suggested to you')
  end

  def match_ur_resource(nominee, resource_owner, matcher)
    @nominee = nominee
    @resource_owner = resource_owner
    @matcher = matcher
    @url_nominee = 'http://kep.thesponge.eu/apps/match/dashboard/' + what + "/" + id.to_s
    @url_matcher  = 'http://kep.thesponge.eu/apps/match/dashboard/' + what + "/" + id.to_s
    mail(to: @resource_owner.email, subject: 'Somebody was suggested for your resource')
  end

end
