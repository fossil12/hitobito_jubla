# encoding: utf-8

#  Copyright (c) 2012-2013, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

ch = Group.roots.first
srand(42)
def contacts
  { short_name: ('A'..'Z').to_a.sample(2).join,
    address: Faker::Address.street_address,
    zip_code: Faker::Address.zip,
    town: Faker::Address.city,
    country: 'Svizzera',
    email: Faker::Internet.safe_email
  }
end
unless ch.address.present?
  ch.update_attributes(contacts)
  ch.default_children.each do |child_class|
    child_class.first.update_attributes(contacts)
  end
end

Group::FederalWorkGroup.seed(:name, :parent_id,
  {name: 'AG Bundeslager',
   parent_id: ch.id },
)

states = Group::State.seed(:name, :parent_id,
  {name: 'Kanton Bern',
   short_name: 'BE',
   address: "Klostergasse 3",
   zip_code: "3333",
   town: "Bern",
   country: "Svizzera",
   email: "bern@be.ch",
   parent_id: ch.id},

  {name: 'Kanton Zürich',
   short_name: 'ZH',
   address: "Tellgasse 3",
   zip_code: "8888",
   town: "Zürich",
   country: "Svizzera",
   email: "zuerich@zh.ch",
   parent_id: ch.id },

  {name: 'Kanton Nordost',
   short_name: 'NO',
   address: "Nordostgasse 3",
   zip_code: "9000",
   town: "Nordosthausen",
   country: "Svizzera",
   email: "nordost@nordost.ch",
   parent_id: ch.id },

  {name: 'Kanton Luzern',
   short_name: 'LU',
   address: "Kramgasse 3",
   zip_code: "4000",
   town: "Luzern",
   country: "Svizzera",
   email: "luzern@lu.ch",
   parent_id: ch.id },

  {name: 'Kanton Schaffhausen',
   short_name: 'SH',
   address: "Hauptstrasse 3",
   zip_code: "9500",
   town: "Stein",
   country: "Svizzera",
   email: "stein@jubla.ch",
   parent_id: ch.id },

  {name: 'Kanton Unterwalden',
   short_name: 'UW',
   address: "Hohle Gasse 3",
   zip_code: "4600",
   town: "Stans",
   country: "Schweiz",
   email: "uw@tell.ch",
   parent_id: ch.id },
)

states.each do |s|
  SocialAccount.seed(:contactable_id, :contactable_type, :name,
    { contactable_id:   s.id,
      contactable_type: 'Group',
      name:             'info@group.ch',
      label:            'E-Mail',
      public:           true }
  )

  PhoneNumber.seed(:contactable_id, :contactable_type, :number,
    { contactable_id:   s.id,
      contactable_type: 'Group',
      number:           Faker::PhoneNumber.phone_number,
      label:            Settings.phone_number.predefined_labels.first,
      public:           true }
  )
  ast = s.children.where(type: 'Group::StateAgency').first
  ast.update_attributes(contacts)
end

Group::StateProfessionalGroup.seed(:name, :parent_id,
  {name: 'FG Sicherheit',
   parent_id: states[0].id },

  {name: 'FG Security',
   parent_id: states[2].id },
)

Group::StateWorkGroup.seed(:name, :parent_id,
  {name: 'AG Kantonslager',
   parent_id: states[0].id },
)

regions = Group::Region.seed(:name, :parent_id,
  {name: 'Region Stadt',
   parent_id: states[0].id }.merge(contacts),

  {name: 'Region Oberland',
   parent_id: states[0].id }.merge(contacts),

  {name: 'Region Jura',
   parent_id: states[0].id }.merge(contacts),

  {name: 'Region Stadt',
   parent_id: states[1].id }.merge(contacts),

  {name: 'Region Oberland',
   parent_id: states[1].id }.merge(contacts),
)

flocks = Group::Flock.seed(:name, :parent_id,
  {name: 'Bern',
   kind: 'Jungwacht',
   parent_id: regions[0].id },

  {name: 'Muri',
   kind: 'Blauring',
   parent_id: regions[0].id },

  {name: 'Thun',
   kind: 'Jungwacht',
   parent_id: regions[1].id },

  {name: 'Interlaken',
   kind: 'Jubla',
   parent_id: regions[1].id },

  {name: 'Simmental',
   kind: 'Jungwacht',
   parent_id: regions[1].id },

  {name: 'Biel',
   kind: 'Blauring',
   parent_id: regions[2].id },

  {name: 'Chräis Chäib',
   kind: 'Jubla',
   parent_id: regions[3].id },

  {name: 'Wiedikon',
   kind: 'Jubla',
   parent_id: regions[3].id },

  {name: 'Innerroden',
   kind: 'Blauring',
   parent_id: states[2].id },

  {name: 'Ausserroden',
   kind: 'Jungwacht',
   parent_id: states[2].id },
)

flocks.each do |s|
  SocialAccount.seed(:contactable_id, :contactable_type, :label,
    { contactable_id:   s.id,
      contactable_type: 'Group',
      name:             'info@flocks.ch',
      label:            'E-Mail',
      public:           true }
  )

  PhoneNumber.seed(:contactable_id, :contactable_type, :label,
    { contactable_id:   s.id,
      contactable_type: 'Group',
      number:           Faker::PhoneNumber.phone_number,
      label:            Settings.phone_number.predefined_labels.first,
      public:           true },
  )
end

Group::ChildGroup.seed(:name, :parent_id,
  {name: 'Asterix',
   parent_id: flocks[0].id },

  {name: 'Obelix',
   parent_id: flocks[0].id },

  {name: 'Idefix',
   parent_id: flocks[0].id },

  {name: 'Mickey',
   parent_id: flocks[1].id },

  {name: 'Minnie',
   parent_id: flocks[2].id },

  {name: 'Goofy',
   parent_id: flocks[3].id },

  {name: 'Donald',
   parent_id: flocks[4].id },

  {name: 'Gaston',
   parent_id: flocks[5].id },

  {name: 'Tim',
   parent_id: flocks[6].id },

  {name: 'Hadock',
   parent_id: flocks[7].id },

  {name: 'Batman',
   parent_id: flocks[8].id },

  {name: 'Robin',
   parent_id: flocks[8].id },

  {name: 'Spiderman',
   parent_id: flocks[9].id },

)

Group::SimpleGroup.seed(:name, :parent_id,
  {name: 'Tschutter',
   parent_id: flocks[0].id },

  {name: 'Angestellte',
   parent_id: states[0].id },
)


Group.rebuild!
