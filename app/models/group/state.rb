# encoding: utf-8

#  Copyright (c) 2012-2013, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

# Ebene Kanton
class Group::State < Group
  
  self.layer = true
  self.default_children = [Group::StateAgency, Group::StateBoard]
  self.contact_group_type = Group::StateAgency
  self.event_types = [Event, Event::Course]
  
    
  class Coach < Jubla::Role::Coach
  end

  class GroupAdmin < Jubla::Role::GroupAdmin
  end

  class Alumnus < Jubla::Role::Alumnus
  end

  class External < Jubla::Role::External
  end

  class DispatchAddress < Jubla::Role::DispatchAddress
  end

  
  roles Coach, GroupAdmin, Alumnus, External, DispatchAddress
  
  children Group::StateAgency,
           Group::StateBoard,
           Group::StateProfessionalGroup,
           Group::StateWorkGroup,
           Group::Region,
           Group::Flock
           
           
  attr_accessible *(accessible_attributes.to_a + [:jubla_insurance, :jubla_full_coverage]), :as => :superior
  
  def census_total(year)
    MemberCount.total_by_states(year).where(state_id: id).first
  end
  
  def census_groups(year)
    MemberCount.total_by_flocks(year, self)
  end
  
  def census_details(year)
    MemberCount.details_for_state(year, self)
  end
  
end
