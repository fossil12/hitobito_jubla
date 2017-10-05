# encoding: utf-8

#  Copyright (c) 2012-2013, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

require 'spec_helper'

describe CensusInvitationJob do

  subject { CensusInvitationJob.new(Census.current) }

  describe '#recipients' do
    it 'contains all leaders in the system' do
      double_role = Fabricate(:person)
      all = [people(:flock_leader_bern), people(:flock_leader)]
      all << Fabricate(Group::StateAgency::Leader.name.to_sym, group: groups(:be_agency), person: double_role).person
      all << Fabricate(Group::Flock::Leader.name.to_sym, group: groups(:bern)).person
      all << Fabricate(Group::Flock::Leader.name.to_sym, group: groups(:bern)).person
      # double
      Fabricate(Group::Flock::Leader.name.to_sym, group: groups(:bern), person: double_role)
      # empty email
      all << Fabricate(Group::Flock::Leader.name.to_sym, group: groups(:bern), person: Fabricate(:person, email: '')).person
      # different role
      Fabricate(Group::Flock::Guide.name.to_sym, group: groups(:bern))

      expect(subject.recipients).to match_array(all)
    end
  end

  describe '#perform' do
    it 'sends email if flock has leaders' do
      expect { subject.perform }.to change { ActionMailer::Base.deliveries.size }.by(1)
    end
  end

end
