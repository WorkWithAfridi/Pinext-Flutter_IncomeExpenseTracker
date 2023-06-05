import 'dart:convert';

class CountryHandler {
  factory CountryHandler() {
    _instance = CountryHandler._internal();
    _instance._setUpCountryList();
    return _instance;
  }
  CountryHandler._internal();
  static late CountryHandler _instance;

  List<CountryData> countryList = [];

  final _countryMap = [
    {'name': 'Afghanistan', 'code': 'AF', 'currency': 'Afghan afghani', 'symbol': '؋', 'symbolPlacement': 'right'},
    {'name': 'Albania', 'code': 'AL', 'currency': 'Albanian lek', 'symbol': 'L', 'symbolPlacement': 'left'},
    {'name': 'Algeria', 'code': 'DZ', 'currency': 'Algerian dinar', 'symbol': 'د.ج', 'symbolPlacement': 'right'},
    {'name': 'Andorra', 'code': 'AD', 'currency': 'Euro', 'symbol': '€', 'symbolPlacement': 'right'},
    {'name': 'Angola', 'code': 'AO', 'currency': 'Angolan kwanza', 'symbol': 'Kz', 'symbolPlacement': 'left'},
    {'name': 'Antigua and Barbuda', 'code': 'AG', 'currency': 'East Caribbean dollar', 'symbol': r'$', 'symbolPlacement': 'left'},
    {'name': 'Argentina', 'code': 'AR', 'currency': 'Argentine peso', 'symbol': r'$', 'symbolPlacement': 'left'},
    {'name': 'Armenia', 'code': 'AM', 'currency': 'Armenian dram', 'symbol': '֏', 'symbolPlacement': 'right'},
    {'name': 'Australia', 'code': 'AU', 'currency': 'Australian dollar', 'symbol': r'$', 'symbolPlacement': 'left'},
    {'name': 'Austria', 'code': 'AT', 'currency': 'Euro', 'symbol': '€', 'symbolPlacement': 'right'},
    {'name': 'Azerbaijan', 'code': 'AZ', 'currency': 'Azerbaijani manat', 'symbol': '₼', 'symbolPlacement': 'right'},
    {'name': 'Bahamas', 'code': 'BS', 'currency': 'Bahamian dollar', 'symbol': r'$', 'symbolPlacement': 'left'},
    {'name': 'Bahrain', 'code': 'BH', 'currency': 'Bahraini dinar', 'symbol': 'ب.د', 'symbolPlacement': 'right'},
    {'name': 'Bangladesh', 'code': 'BD', 'currency': 'Bangladeshi taka', 'symbol': '৳', 'symbolPlacement': 'left'},
    {'name': 'Barbados', 'code': 'BB', 'currency': 'Barbadian dollar', 'symbol': r'$', 'symbolPlacement': 'left'},
    {'name': 'Belarus', 'code': 'BY', 'currency': 'Belarusian ruble', 'symbol': 'Br', 'symbolPlacement': 'right'},
    {'name': 'Belgium', 'code': 'BE', 'currency': 'Euro', 'symbol': '€', 'symbolPlacement': 'right'},
    {'name': 'Belize', 'code': 'BZ', 'currency': 'Belize dollar', 'symbol': r'$', 'symbolPlacement': 'left'},
    {'name': 'Benin', 'code': 'BJ', 'currency': 'West African CFA franc', 'symbol': 'CFA', 'symbolPlacement': 'left'},
    {'name': 'Bhutan', 'code': 'BT', 'currency': 'Bhutanese ngultrum', 'symbol': 'Nu.', 'symbolPlacement': 'right'},
    {'name': 'Bolivia', 'code': 'BO', 'currency': 'Bolivian boliviano', 'symbol': 'Bs.', 'symbolPlacement': 'left'},
    {'name': 'Bosnia and Herzegovina', 'code': 'BA', 'currency': 'Bosnia and Herzegovina convertible mark', 'symbol': 'KM', 'symbolPlacement': 'right'},
    {'name': 'Botswana', 'code': 'BW', 'currency': 'Botswana pula', 'symbol': 'P', 'symbolPlacement': 'left'},
    {'name': 'Brazil', 'code': 'BR', 'currency': 'Brazilian real', 'symbol': r'R$', 'symbolPlacement': 'left'},
    {'name': 'Brunei', 'code': 'BN', 'currency': 'Brunei dollar', 'symbol': r'$', 'symbolPlacement': 'left'},
    {'name': 'Bulgaria', 'code': 'BG', 'currency': 'Bulgarian lev', 'symbol': 'лв', 'symbolPlacement': 'right'},
    {'name': 'Burkina Faso', 'code': 'BF', 'currency': 'West African CFA franc', 'symbol': 'CFA', 'symbolPlacement': 'left'},
    {'name': 'Burundi', 'code': 'BI', 'currency': 'Burundian franc', 'symbol': 'FBu', 'symbolPlacement': 'right'},
    {'name': 'Cabo Verde', 'code': 'CV', 'currency': 'Cape Verdean escudo', 'symbol': 'Esc', 'symbolPlacement': 'right'},
    {'name': 'Cambodia', 'code': 'KH', 'currency': 'Cambodian riel', 'symbol': '៛', 'symbolPlacement': 'right'},
    {'name': 'Cameroon', 'code': 'CM', 'currency': 'Central African CFA franc', 'symbol': 'CFA', 'symbolPlacement': 'left'},
    {'name': 'Canada', 'code': 'CA', 'currency': 'Canadian dollar', 'symbol': r'$', 'symbolPlacement': 'left'},
    {'name': 'Central African Republic', 'code': 'CF', 'currency': 'Central African CFA franc', 'symbol': 'CFA', 'symbolPlacement': 'left'},
    {'name': 'Chad', 'code': 'TD', 'currency': 'Central African CFA franc', 'symbol': 'CFA', 'symbolPlacement': 'left'},
    {'name': 'Chile', 'code': 'CL', 'currency': 'Chilean peso', 'symbol': r'$', 'symbolPlacement': 'left'},
    {'name': 'China', 'code': 'CN', 'currency': 'Chinese yuan', 'symbol': '¥', 'symbolPlacement': 'left'},
    {'name': 'Colombia', 'code': 'CO', 'currency': 'Colombian peso', 'symbol': r'$', 'symbolPlacement': 'left'},
    {'name': 'Comoros', 'code': 'KM', 'currency': 'Comorian franc', 'symbol': 'CF', 'symbolPlacement': 'left'},
    {'name': 'Congo (Brazzaville)', 'code': 'CG', 'currency': 'Central African CFA franc', 'symbol': 'CFA', 'symbolPlacement': 'left'},
    {'name': 'Congo (Kinshasa)', 'code': 'CD', 'currency': 'Congolese franc', 'symbol': 'FC', 'symbolPlacement': 'left'},
    {'name': 'Costa Rica', 'code': 'CR', 'currency': 'Costa Rican colón', 'symbol': '₡', 'symbolPlacement': 'left'},
    {'name': 'Croatia', 'code': 'HR', 'currency': 'Croatian kuna', 'symbol': 'kn', 'symbolPlacement': 'right'},
    {'name': 'Cuba', 'code': 'CU', 'currency': 'Cuban peso', 'symbol': r'$', 'symbolPlacement': 'left'},
    {'name': 'Cyprus', 'code': 'CY', 'currency': 'Euro', 'symbol': '€', 'symbolPlacement': 'right'},
    {'name': 'Czechia', 'code': 'CZ', 'currency': 'Czech koruna', 'symbol': 'Kč', 'symbolPlacement': 'right'},
    {'name': "Côte d'Ivoire", 'code': 'CI', 'currency': 'West African CFA franc', 'symbol': 'CFA', 'symbolPlacement': 'left'},
    {'name': 'Denmark', 'code': 'DK', 'currency': 'Danish krone', 'symbol': 'kr', 'symbolPlacement': 'left'},
    {'name': 'Djibouti', 'code': 'DJ', 'currency': 'Djiboutian franc', 'symbol': 'Fdj', 'symbolPlacement': 'right'},
    {'name': 'Dominica', 'code': 'DM', 'currency': 'East Caribbean dollar', 'symbol': r'$', 'symbolPlacement': 'left'},
    {'name': 'Dominican Republic', 'code': 'DO', 'currency': 'Dominican peso', 'symbol': r'RD$', 'symbolPlacement': 'left'},
    {'name': 'Ecuador', 'code': 'EC', 'currency': 'United States dollar', 'symbol': r'$', 'symbolPlacement': 'left'},
    {'name': 'Egypt', 'code': 'EG', 'currency': 'Egyptian pound', 'symbol': '£', 'symbolPlacement': 'left'},
    {'name': 'El Salvador', 'code': 'SV', 'currency': 'United States dollar', 'symbol': r'$', 'symbolPlacement': 'left'},
    {'name': 'Equatorial Guinea', 'code': 'GQ', 'currency': 'Central African CFA franc', 'symbol': 'CFA', 'symbolPlacement': 'left'},
    {'name': 'Eritrea', 'code': 'ER', 'currency': 'Eritrean nakfa', 'symbol': 'Nfk', 'symbolPlacement': 'right'},
    {'name': 'Estonia', 'code': 'EE', 'currency': 'Euro', 'symbol': '€', 'symbolPlacement': 'right'},
    {'name': 'Eswatini', 'code': 'SZ', 'currency': 'Swazi lilangeni', 'symbol': 'L', 'symbolPlacement': 'left'},
    {'name': 'Ethiopia', 'code': 'ET', 'currency': 'Ethiopian birr', 'symbol': 'Br', 'symbolPlacement': 'right'},
    {'name': 'Fiji', 'code': 'FJ', 'currency': 'Fijian dollar', 'symbol': r'$', 'symbolPlacement': 'left'},
    {'name': 'Finland', 'code': 'FI', 'currency': 'Euro', 'symbol': '€', 'symbolPlacement': 'right'},
    {'name': 'France', 'code': 'FR', 'currency': 'Euro', 'symbol': '€', 'symbolPlacement': 'right'},
    {'name': 'Gabon', 'code': 'GA', 'currency': 'Central African CFA franc', 'symbol': 'CFA', 'symbolPlacement': 'left'},
    {'name': 'Gambia', 'code': 'GM', 'currency': 'Gambian dalasi', 'symbol': 'D', 'symbolPlacement': 'left'},
    {'name': 'Georgia', 'code': 'GE', 'currency': 'Georgian lari', 'symbol': '₾', 'symbolPlacement': 'right'},
    {'name': 'Germany', 'code': 'DE', 'currency': 'Euro', 'symbol': '€', 'symbolPlacement': 'right'},
    {'name': 'Ghana', 'code': 'GH', 'currency': 'Ghanaian cedi', 'symbol': '₵', 'symbolPlacement': 'right'},
    {'name': 'Greece', 'code': 'GR', 'currency': 'Euro', 'symbol': '€', 'symbolPlacement': 'right'},
    {'name': 'Grenada', 'code': 'GD', 'currency': 'East Caribbean dollar', 'symbol': r'$', 'symbolPlacement': 'left'},
    {'name': 'Guatemala', 'code': 'GT', 'currency': 'Guatemalan quetzal', 'symbol': 'Q', 'symbolPlacement': 'left'},
    {'name': 'Guinea', 'code': 'GN', 'currency': 'Guinean franc', 'symbol': 'FG', 'symbolPlacement': 'left'},
    {'name': 'Guinea-Bissau', 'code': 'GW', 'currency': 'West African CFA franc', 'symbol': 'CFA', 'symbolPlacement': 'left'},
    {'name': 'Guyana', 'code': 'GY', 'currency': 'Guyanese dollar', 'symbol': r'$', 'symbolPlacement': 'left'},
    {'name': 'Haiti', 'code': 'HT', 'currency': 'Haitian gourde', 'symbol': 'G', 'symbolPlacement': 'left'},
    {'name': 'Honduras', 'code': 'HN', 'currency': 'Honduran lempira', 'symbol': 'L', 'symbolPlacement': 'left'},
    {'name': 'Hungary', 'code': 'HU', 'currency': 'Hungarian forint', 'symbol': 'Ft', 'symbolPlacement': 'right'},
    {'name': 'Iceland', 'code': 'IS', 'currency': 'Icelandic króna', 'symbol': 'kr', 'symbolPlacement': 'right'},
    {'name': 'India', 'code': 'IN', 'currency': 'Indian rupee', 'symbol': '₹', 'symbolPlacement': 'right'},
    {'name': 'Indonesia', 'code': 'ID', 'currency': 'Indonesian rupiah', 'symbol': 'Rp', 'symbolPlacement': 'left'},
    {'name': 'Iran', 'code': 'IR', 'currency': 'Iranian rial', 'symbol': '﷼', 'symbolPlacement': 'right'},
    {'name': 'Iraq', 'code': 'IQ', 'currency': 'Iraqi dinar', 'symbol': 'ع.د', 'symbolPlacement': 'right'},
    {'name': 'Ireland', 'code': 'IE', 'currency': 'Euro', 'symbol': '€', 'symbolPlacement': 'right'},
    {'name': 'Israel', 'code': 'IL', 'currency': 'Israeli new shekel', 'symbol': '₪', 'symbolPlacement': 'right'},
    {'name': 'Italy', 'code': 'IT', 'currency': 'Euro', 'symbol': '€', 'symbolPlacement': 'right'},
    {'name': 'Jamaica', 'code': 'JM', 'currency': 'Jamaican dollar', 'symbol': r'$', 'symbolPlacement': 'left'},
    {'name': 'Japan', 'code': 'JP', 'currency': 'Japanese yen', 'symbol': '¥', 'symbolPlacement': 'left'},
    {'name': 'Jordan', 'code': 'JO', 'currency': 'Jordanian dinar', 'symbol': 'د.ا', 'symbolPlacement': 'right'},
    {'name': 'Kazakhstan', 'code': 'KZ', 'currency': 'Kazakhstani tenge', 'symbol': '₸', 'symbolPlacement': 'right'},
    {'name': 'Kenya', 'code': 'KE', 'currency': 'Kenyan shilling', 'symbol': 'KSh', 'symbolPlacement': 'right'},
    {'name': 'Kiribati', 'code': 'KI', 'currency': 'Australian dollar', 'symbol': r'$', 'symbolPlacement': 'left'},
    {'name': 'Kuwait', 'code': 'KW', 'currency': 'Kuwaiti dinar', 'symbol': 'د.ك', 'symbolPlacement': 'left'},
    {'name': 'Kyrgyzstan', 'code': 'KG', 'currency': 'Kyrgyzstani som', 'symbol': 'с', 'symbolPlacement': 'right'},
    {'name': 'Laos', 'code': 'LA', 'currency': 'Lao kip', 'symbol': '₭', 'symbolPlacement': 'left'},
    {'name': 'Latvia', 'code': 'LV', 'currency': 'Euro', 'symbol': '€', 'symbolPlacement': 'right'},
    {'name': 'Lebanon', 'code': 'LB', 'currency': 'Lebanese pound', 'symbol': 'ل.ل', 'symbolPlacement': 'right'},
    {'name': 'Lesotho', 'code': 'LS', 'currency': 'Lesotho loti', 'symbol': 'L', 'symbolPlacement': 'left'},
    {'name': 'Liberia', 'code': 'LR', 'currency': 'Liberian dollar', 'symbol': r'$', 'symbolPlacement': 'left'},
    {'name': 'Libya', 'code': 'LY', 'currency': 'Libyan dinar', 'symbol': 'ل.د', 'symbolPlacement': 'right'},
    {'name': 'Liechtenstein', 'code': 'LI', 'currency': 'Swiss franc', 'symbol': 'CHF', 'symbolPlacement': 'right'},
    {'name': 'Lithuania', 'code': 'LT', 'currency': 'Euro', 'symbol': '€', 'symbolPlacement': 'right'},
    {'name': 'Luxembourg', 'code': 'LU', 'currency': 'Euro', 'symbol': '€', 'symbolPlacement': 'right'},
    {'name': 'Madagascar', 'code': 'MG', 'currency': 'Malagasy ariary', 'symbol': 'Ar', 'symbolPlacement': 'right'},
    {'name': 'Malawi', 'code': 'MW', 'currency': 'Malawian kwacha', 'symbol': 'MK', 'symbolPlacement': 'left'},
    {'name': 'Malaysia', 'code': 'MY', 'currency': 'Malaysian ringgit', 'symbol': 'RM', 'symbolPlacement': 'left'},
    {'name': 'Maldives', 'code': 'MV', 'currency': 'Maldivian rufiyaa', 'symbol': 'Rf', 'symbolPlacement': 'left'},
    {'name': 'Mali', 'code': 'ML', 'currency': 'West African CFA franc', 'symbol': 'CFA', 'symbolPlacement': 'left'},
    {'name': 'Malta', 'code': 'MT', 'currency': 'Euro', 'symbol': '€', 'symbolPlacement': 'right'},
    {'name': 'Marshall Islands', 'code': 'MH', 'currency': 'United States dollar', 'symbol': r'$', 'symbolPlacement': 'left'},
    {'name': 'Mauritania', 'code': 'MR', 'currency': 'Mauritanian ouguiya', 'symbol': 'UM', 'symbolPlacement': 'right'},
    {'name': 'Mauritius', 'code': 'MU', 'currency': 'Mauritian rupee', 'symbol': '₨', 'symbolPlacement': 'left'},
    {'name': 'Mexico', 'code': 'MX', 'currency': 'Mexican peso', 'symbol': r'$', 'symbolPlacement': 'left'},
    {'name': 'Micronesia', 'code': 'FM', 'currency': 'United States dollar', 'symbol': r'$', 'symbolPlacement': 'left'},
    {'name': 'Moldova', 'code': 'MD', 'currency': 'Moldovan leu', 'symbol': 'L', 'symbolPlacement': 'left'},
    {'name': 'Monaco', 'code': 'MC', 'currency': 'Euro', 'symbol': '€', 'symbolPlacement': 'right'},
    {'name': 'Mongolia', 'code': 'MN', 'currency': 'Mongolian tögrög', 'symbol': '₮', 'symbolPlacement': 'right'},
    {'name': 'Montenegro', 'code': 'ME', 'currency': 'Euro', 'symbol': '€', 'symbolPlacement': 'right'},
    {'name': 'Morocco', 'code': 'MA', 'currency': 'Moroccan dirham', 'symbol': 'د.م.', 'symbolPlacement': 'right'},
    {'name': 'Mozambique', 'code': 'MZ', 'currency': 'Mozambican metical', 'symbol': 'MT', 'symbolPlacement': 'right'},
    {'name': 'Myanmar', 'code': 'MM', 'currency': 'Burmese kyat', 'symbol': 'Ks', 'symbolPlacement': 'left'},
    {'name': 'Namibia', 'code': 'NA', 'currency': 'Namibian dollar', 'symbol': r'$', 'symbolPlacement': 'left'},
    {'name': 'Nauru', 'code': 'NR', 'currency': 'Australian dollar', 'symbol': r'$', 'symbolPlacement': 'left'},
    {'name': 'Nepal', 'code': 'NP', 'currency': 'Nepalese rupee', 'symbol': '₨', 'symbolPlacement': 'left'},
    {'name': 'Netherlands', 'code': 'NL', 'currency': 'Euro', 'symbol': '€', 'symbolPlacement': 'right'},
    {'name': 'New Zealand', 'code': 'NZ', 'currency': 'New Zealand dollar', 'symbol': r'$', 'symbolPlacement': 'left'},
    {'name': 'Nicaragua', 'code': 'NI', 'currency': 'Nicaraguan córdoba', 'symbol': r'C$', 'symbolPlacement': 'left'},
    {'name': 'Niger', 'code': 'NE', 'currency': 'West African CFA franc', 'symbol': 'CFA', 'symbolPlacement': 'left'},
    {'name': 'Nigeria', 'code': 'NG', 'currency': 'Nigerian naira', 'symbol': '₦', 'symbolPlacement': 'left'},
    {'name': 'North Korea', 'code': 'KP', 'currency': 'North Korean won', 'symbol': '₩', 'symbolPlacement': 'left'},
    {'name': 'North Macedonia', 'code': 'MK', 'currency': 'Macedonian denar', 'symbol': 'ден', 'symbolPlacement': 'right'},
    {'name': 'Norway', 'code': 'NO', 'currency': 'Norwegian krone', 'symbol': 'kr', 'symbolPlacement': 'right'},
    {'name': 'Oman', 'code': 'OM', 'currency': 'Omani rial', 'symbol': 'ر.ع.', 'symbolPlacement': 'right'},
    {'name': 'Pakistan', 'code': 'PK', 'currency': 'Pakistani rupee', 'symbol': '₨', 'symbolPlacement': 'left'},
    {'name': 'Palau', 'code': 'PW', 'currency': 'United States dollar', 'symbol': r'$', 'symbolPlacement': 'left'},
    {'name': 'Panama', 'code': 'PA', 'currency': 'Panamanian balboa', 'symbol': 'B/.', 'symbolPlacement': 'left'},
    {'name': 'Papua New Guinea', 'code': 'PG', 'currency': 'Papua New Guinean kina', 'symbol': 'K', 'symbolPlacement': 'left'},
    {'name': 'Paraguay', 'code': 'PY', 'currency': 'Paraguayan guaraní', 'symbol': '₲', 'symbolPlacement': 'right'},
    {'name': 'Peru', 'code': 'PE', 'currency': 'Peruvian sol', 'symbol': 'S/.', 'symbolPlacement': 'left'},
    {'name': 'Philippines', 'code': 'PH', 'currency': 'Philippine peso', 'symbol': '₱', 'symbolPlacement': 'left'},
    {'name': 'Poland', 'code': 'PL', 'currency': 'Polish złoty', 'symbol': 'zł', 'symbolPlacement': 'left'},
    {'name': 'Portugal', 'code': 'PT', 'currency': 'Euro', 'symbol': '€', 'symbolPlacement': 'right'},
    {'name': 'Qatar', 'code': 'QA', 'currency': 'Qatari riyal', 'symbol': 'ر.ق', 'symbolPlacement': 'right'},
    {'name': 'Romania', 'code': 'RO', 'currency': 'Romanian leu', 'symbol': 'lei', 'symbolPlacement': 'right'},
    {'name': 'Russia', 'code': 'RU', 'currency': 'Russian ruble', 'symbol': '₽', 'symbolPlacement': 'right'},
    {'name': 'Rwanda', 'code': 'RW', 'currency': 'Rwandan franc', 'symbol': 'FRw', 'symbolPlacement': 'right'},
    {'name': 'Saint Kitts and Nevis', 'code': 'KN', 'currency': 'East Caribbean dollar', 'symbol': r'$', 'symbolPlacement': 'left'},
    {'name': 'Saint Lucia', 'code': 'LC', 'currency': 'East Caribbean dollar', 'symbol': r'$', 'symbolPlacement': 'left'},
    {'name': 'Saint Vincent and the Grenadines', 'code': 'VC', 'currency': 'East Caribbean dollar', 'symbol': r'$', 'symbolPlacement': 'left'},
    {'name': 'Samoa', 'code': 'WS', 'currency': 'Samoan tālā', 'symbol': 'T', 'symbolPlacement': 'left'},
    {'name': 'San Marino', 'code': 'SM', 'currency': 'Euro', 'symbol': '€', 'symbolPlacement': 'right'},
    {'name': 'Sao Tome and Principe', 'code': 'ST', 'currency': 'São Tomé and Príncipe dobra', 'symbol': 'Db', 'symbolPlacement': 'right'},
    {'name': 'Saudi Arabia', 'code': 'SA', 'currency': 'Saudi riyal', 'symbol': 'ر.س', 'symbolPlacement': 'right'},
    {'name': 'Senegal', 'code': 'SN', 'currency': 'West African CFA franc', 'symbol': 'CFA', 'symbolPlacement': 'left'},
    {'name': 'Serbia', 'code': 'RS', 'currency': 'Serbian dinar', 'symbol': 'дин', 'symbolPlacement': 'right'},
    {'name': 'Seychelles', 'code': 'SC', 'currency': 'Seychellois rupee', 'symbol': '₨', 'symbolPlacement': 'left'},
    {'name': 'Sierra Leone', 'code': 'SL', 'currency': 'Sierra Leonean leone', 'symbol': 'Le', 'symbolPlacement': 'right'},
    {'name': 'Singapore', 'code': 'SG', 'currency': 'Singapore dollar', 'symbol': r'$', 'symbolPlacement': 'left'},
    {'name': 'Slovakia', 'code': 'SK', 'currency': 'Euro', 'symbol': '€', 'symbolPlacement': 'right'},
    {'name': 'Slovenia', 'code': 'SI', 'currency': 'Euro', 'symbol': '€', 'symbolPlacement': 'right'},
    {'name': 'Solomon Islands', 'code': 'SB', 'currency': 'Solomon Islands dollar', 'symbol': r'$', 'symbolPlacement': 'left'},
    {'name': 'Somalia', 'code': 'SO', 'currency': 'Somali shilling', 'symbol': 'Sh', 'symbolPlacement': 'right'},
    {'name': 'South Africa', 'code': 'ZA', 'currency': 'South African rand', 'symbol': 'R', 'symbolPlacement': 'left'},
    {'name': 'South Korea', 'code': 'KR', 'currency': 'South Korean won', 'symbol': '₩', 'symbolPlacement': 'left'},
    {'name': 'South Sudan', 'code': 'SS', 'currency': 'South Sudanese pound', 'symbol': '£', 'symbolPlacement': 'left'},
    {'name': 'Spain', 'code': 'ES', 'currency': 'Euro', 'symbol': '€', 'symbolPlacement': 'right'},
    {'name': 'Sri Lanka', 'code': 'LK', 'currency': 'Sri Lankan rupee', 'symbol': '₨', 'symbolPlacement': 'left'},
    {'name': 'Sudan', 'code': 'SD', 'currency': 'Sudanese pound', 'symbol': '£', 'symbolPlacement': 'left'},
    {'name': 'Suriname', 'code': 'SR', 'currency': 'Surinamese dollar', 'symbol': r'$', 'symbolPlacement': 'left'},
    {'name': 'Sweden', 'code': 'SE', 'currency': 'Swedish krona', 'symbol': 'kr', 'symbolPlacement': 'right'},
    {'name': 'Switzerland', 'code': 'CH', 'currency': 'Swiss franc', 'symbol': 'CHF', 'symbolPlacement': 'right'},
    {'name': 'Syria', 'code': 'SY', 'currency': 'Syrian pound', 'symbol': '£', 'symbolPlacement': 'right'},
    {'name': 'Taiwan', 'code': 'TW', 'currency': 'New Taiwan dollar', 'symbol': r'NT$', 'symbolPlacement': 'left'},
    {'name': 'Tajikistan', 'code': 'TJ', 'currency': 'Tajikistani somoni', 'symbol': 'ЅМ', 'symbolPlacement': 'right'},
    {'name': 'Tanzania', 'code': 'TZ', 'currency': 'Tanzanian shilling', 'symbol': 'Sh', 'symbolPlacement': 'right'},
    {'name': 'Thailand', 'code': 'TH', 'currency': 'Thai baht', 'symbol': '฿', 'symbolPlacement': 'left'},
    {'name': 'Timor-Leste', 'code': 'TL', 'currency': 'United States dollar', 'symbol': r'$', 'symbolPlacement': 'left'},
    {'name': 'Togo', 'code': 'TG', 'currency': 'West African CFA franc', 'symbol': 'CFA', 'symbolPlacement': 'left'},
    {'name': 'Tonga', 'code': 'TO', 'currency': 'Tongan paʻanga', 'symbol': r'T$', 'symbolPlacement': 'left'},
    {'name': 'Trinidad and Tobago', 'code': 'TT', 'currency': 'Trinidad and Tobago dollar', 'symbol': r'TT$', 'symbolPlacement': 'left'},
    {'name': 'Tunisia', 'code': 'TN', 'currency': 'Tunisian dinar', 'symbol': 'د.ت', 'symbolPlacement': 'right'},
    {'name': 'Turkey', 'code': 'TR', 'currency': 'Turkish lira', 'symbol': '₺', 'symbolPlacement': 'left'},
    {'name': 'Turkmenistan', 'code': 'TM', 'currency': 'Turkmenistan manat', 'symbol': 'T', 'symbolPlacement': 'left'},
    {'name': 'Tuvalu', 'code': 'TV', 'currency': 'Australian dollar', 'symbol': r'$', 'symbolPlacement': 'left'},
    {'name': 'Uganda', 'code': 'UG', 'currency': 'Ugandan shilling', 'symbol': 'Sh', 'symbolPlacement': 'right'},
    {'name': 'Ukraine', 'code': 'UA', 'currency': 'Ukrainian hryvnia', 'symbol': '₴', 'symbolPlacement': 'right'},
    {'name': 'United Arab Emirates', 'code': 'AE', 'currency': 'United Arab Emirates dirham', 'symbol': 'د.إ', 'symbolPlacement': 'right'},
    {'name': 'United Kingdom', 'code': 'GB', 'currency': 'British pound', 'symbol': '£', 'symbolPlacement': 'left'},
    {'name': 'United States', 'code': 'US', 'currency': 'United States dollar', 'symbol': r'$', 'symbolPlacement': 'left'},
    {'name': 'Uruguay', 'code': 'UY', 'currency': 'Uruguayan peso', 'symbol': r'$', 'symbolPlacement': 'left'},
    {'name': 'Uzbekistan', 'code': 'UZ', 'currency': 'Uzbekistani som', 'symbol': 'лв', 'symbolPlacement': 'left'},
    {'name': 'Vanuatu', 'code': 'VU', 'currency': 'Vanuatu vatu', 'symbol': 'Vt', 'symbolPlacement': 'right'},
    {'name': 'Vatican City', 'code': 'VA', 'currency': 'Euro', 'symbol': '€', 'symbolPlacement': 'right'},
    {'name': 'Venezuela', 'code': 'VE', 'currency': 'Venezuelan bolívar', 'symbol': 'Bs.', 'symbolPlacement': 'right'},
    {'name': 'Vietnam', 'code': 'VN', 'currency': 'Vietnamese đồng', 'symbol': '₫', 'symbolPlacement': 'right'},
    {'name': 'Yemen', 'code': 'YE', 'currency': 'Yemeni rial', 'symbol': '﷼', 'symbolPlacement': 'left'},
    {'name': 'Zambia', 'code': 'ZM', 'currency': 'Zambian kwacha', 'symbol': 'ZK', 'symbolPlacement': 'right'},
    {'name': 'Zimbabwe', 'code': 'ZW', 'currency': 'Zimbabwean dollar', 'symbol': r'$', 'symbolPlacement': 'left'}
  ];

  void _setUpCountryList() {
    // for (final country in _countryMap) {
    //   countryList.add(CountryData.fromMap(country));
    // }

    // // Sort the list based on country name
    // countryList.sort((a, b) => a.name.compareTo(b.name));

    // // Remove duplicates based on country name
    // final uniqueCountries = <CountryData>[];
    // var previousName = '';

    // for (final country in countryList) {
    //   if (country.name != previousName) {
    //     uniqueCountries.add(country);
    //     previousName = country.name;
    //   }
    // }
    // countryList = uniqueCountries;
    for (final country in _countryMap) {
      countryList.add(CountryData.fromMap(country));
    }
  }
}

class CountryData {
  CountryData({
    required this.name,
    required this.code,
    required this.currency,
    required this.symbol,
    required this.symbolPlacement,
  });
  factory CountryData.fromJson(String source) => CountryData.fromMap(json.decode(source) as Map<String, dynamic>);

  factory CountryData.fromMap(Map<String, dynamic> map) {
    return CountryData(
      name: map['name'] as String,
      code: map['code'] as String,
      currency: map['currency'] as String,
      symbol: map['symbol'] as String,
      symbolPlacement: map['symbolPlacement'] as String,
    );
  }
  String name;
  String code;
  String currency;
  String symbol;
  String symbolPlacement;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'code': code,
      'currency': currency,
      'symbol': symbol,
      'symbolPlacement': symbolPlacement,
    };
  }

  String toJson() => json.encode(toMap());
}