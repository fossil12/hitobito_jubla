# encoding: utf-8

#  Copyright (c) 2012-2013, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

# Bundesleitung
class Group::FederalBoard < Group

  class Member < Jubla::Role::Member
    self.permissions = [:admin, :layer_full, :contact_data]

    attr_accessible :employment_percent
  end

  class President < Member
    attr_accessible :honorary
  end

  class GroupAdmin < Jubla::Role::GroupAdmin
  end

  class Alumnus < Jubla::Role::Alumnus
  end

  class External < Jubla::Role::External
  end

  class DispatchAddress < Jubla::Role::DispatchAddress
  end

  roles Member, President, GroupAdmin, Alumnus, External, DispatchAddress

end
