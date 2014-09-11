# encoding: utf-8

#  Copyright (c) 2012-2013, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

class AddRemarksAndSignatureToEvent < ActiveRecord::Migration
  def change
    add_column(:events, :signature, :boolean)
    add_column(:events, :signature_confirmation, :boolean)
    add_column(:events, :signature_confirmation_text, :string)
    add_column(:events, :remarks, :text)
  end
end