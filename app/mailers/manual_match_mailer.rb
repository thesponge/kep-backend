class ManualMatchMailer < ApplicationMailer

  def match_uu(nominee, second_nominee, matcher)
    @nominee = nominee
    @second_nominee = second_nominee
    @matcher = matcher
    @url_matcher  = 'http://kep.thesponge.eu/users/' + @matcher.id.to_s + "/profile"
    @url_second_nominee = 'http://kep.thesponge.eu/users/'  + @second_nominee.id.to_s + "/profile"
    mail(to: @nominee.email, subject: 'Shared interests')
    #???Ask Stefan to write/review the emails
  end

  def match_ur_nominee(nominee, resource, matcher)
    @nominee = nominee
    @resource = resource
    @matcher = matcher
    @url_resource = 'http://kep.thesponge.eu/resources/' + @resource.id.to_s
    @url_matcher  = 'http://kep.thesponge.eu/users/' + @matcher.id.to_s + "/profile"
    mail(to: @nominee.email, subject: 'A resource has been suggested to you')
  end

  def match_ur_resource(nominee, resource, matcher)
    @nominee = nominee
    @resource = resource
    @matcher = matcher
    @url_resource = 'http://kep.thesponge.eu/resources/' + @resource.id.to_s
    @url_nominee = 'http://kep.thesponge.eu/users/' + @nominee.id.to_s + "/profile"
    @url_matcher  = 'http://kep.thesponge.eu/users/' + @matcher.id.to_s + "/profile"
    mail(to: @resource.user.email, subject: 'Somebody was suggested for your resource')
  end

  def match_ar_assign(assign, resource, matcher)
    @assign = assign
    @resource = resource
    @matcher = matcher
    @url_mather = 'http://kep.thesponge.eu/users/' + @matcher.id.to_s + "/profile"
    @url_assign = 'http://kep.thesponge.eu/assignments/' + @assign.id.to_s
    @url_resource = 'http://kep.thesponge.eu/resources/' + @resource.id.to_s
    mail(to: @assign.user.email, subject: 'Somebody found a resource for your assignment')
  end

  def match_ar_resource(assign, resource, matcher)
    @assign = assign
    @resource = resource
    @matcher = matcher
    @url_mather = 'http://kep.thesponge.eu/users/' + @matcher.id.to_s + "/profile"
    @url_assign = 'http://kep.thesponge.eu/assignments/' + @assign.id.to_s
    @url_resource = 'http://kep.thesponge.eu/resources/' + @resource.id.to_s
    mail(to: @resource.user.email, subject: 'Somebody found an assignment that could use your resource')
  end


end
