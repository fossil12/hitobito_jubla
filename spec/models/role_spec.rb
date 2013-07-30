# encoding: utf-8

#  Copyright (c) 2012-2013, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

require 'spec_helper'

describe Role do

  describe Group::Flock::Leader do
    subject { Group::Flock::Leader }

    it { should_not be_affiliate }
    it { should be_visible_from_above }
    it { should_not be_external }

    its(:permissions) { should ==  [:layer_full, :contact_data, :approve_applications] }

    it "may be created for flock" do
      role = Fabricate.build(subject.name.to_sym, group: groups(:bern))
      role.should be_valid
    end

    it "may not be created for region" do
      role = Fabricate.build(subject.name.to_sym, group: groups(:city))
      role.should_not be_valid
      role.should have(1).error_on(:type)
    end
  end

  describe Group::Region::External do
    subject { Group::Region::External }

    it { should be_affiliate }
    it { should_not be_visible_from_above }
    it { should be_external }

    its(:permissions) { should ==  [] }

    it "may be created for region" do
      role = Fabricate.build(subject.name.to_sym, group: groups(:city))
      role.should be_valid
    end
  end

  describe Group::Region::Alumnus do
    subject { Group::Region::Alumnus }

    it { should be_affiliate }
    it { should be_visible_from_above }
    it { should_not be_external }

    its(:permissions) { should ==  [:group_read] }

    it "may be created for region" do
      role = Fabricate.build(subject.name.to_sym, group: groups(:city))
      role.should be_valid
    end
  end

  describe "#all_types" do
    subject { Role.all_types }

    it "starts with top most role" do
      subject.first.should == Group::Federation::GroupAdmin
    end

    it "finishes with bottom most role" do
      subject.last.should == Group::SimpleGroup::DispatchAddress
    end
  end


  context "#destroy" do
    let(:role) { Fabricate(role_class.name.to_s, group: groups(:bern), created_at: created_at) }
    let(:role_class) { Group::Flock::Leader }
    let(:created_at) { Time.zone.now }

    context "young role" do
      it "deletes from database" do
        expect { role.destroy }.not_to change { Group::Flock::Alumnus.count }
        Role.with_deleted.where(id: role.id).should_not be_exists
      end
    end

    context "old roles" do
      let(:created_at) { Time.zone.now - Settings.role.minimum_days_to_archive.days - 1.day }

      context "single role" do
        it "flags as deleted, creates alumnus role" do
          expect { role.destroy }.to change { Group::Flock::Alumnus.count }.by(1)
          Role.only_deleted.find(role.id).should be_present
        end
      end

      context "multiple roles" do
        before { Fabricate(role_class.name.to_s, group: groups(:bern), person: role.person, created_at: created_at) }

        it "flags as deleted, does not create alumnus role" do
          expect { role.destroy }.not_to change { Group::Flock::Alumnus.count }
          Role.only_deleted.find(role.id).should be_present
        end
      end

      context "external role" do
        let(:role_class) { Group::Flock::External }

        it "flags as deleted, does not create alumnus role" do
          expect { role.destroy }.not_to change { Group::Flock::Alumnus.count }
          Role.only_deleted.find(role.id).should be_present
        end
      end

      context "alumnus role" do
        let(:role_class) { Group::Flock::Alumnus }
        before { role } # ensure we have created the original Alumnus role before expecting

        it "can be destroyed, creates new alumnus role" do
          expect { role.destroy }.not_to change { Group::Flock::Alumnus.count }
        end
      end
    end
  end
end
