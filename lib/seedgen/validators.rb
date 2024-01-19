module SeedGen
  VALIDATORS = %w[
    ActiveModel::BlockValidator
    ActiveModel::Validations::AbsenceValidator
    ActiveModel::Validations::AcceptanceValidator
    ActiveModel::Validations::ConfirmationValidator
    ActiveModel::Validations::ComparisonValidator
    ActiveModel::Validations::ExclusionValidator
    ActiveModel::Validations::FormatValidator
    ActiveModel::Validations::InclusionValidator
    ActiveModel::Validations::LengthValidator
    ActiveModel::Validations::NumericalityValidator
    ActiveModel::Validations::PresenceValidator
    ActiveModel::Validations::WithValidator
    ActiveRecord::Validations::AbsenceValidator
    ActiveRecord::Validations::AssociatedValidator
    ActiveRecord::Validations::LengthValidator
    ActiveRecord::Validations::NumericalityValidator
    ActiveRecord::Validations::PresenceValidator
    ActiveRecord::Validations::UniquenessValidator
  ]
end