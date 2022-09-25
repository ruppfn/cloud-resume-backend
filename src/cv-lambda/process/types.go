package process

type DynamoData struct {
	Id             string          `json:"id"`
	Name           string          `json:"name"`
	Role           string          `json:"role"`
	ContactInfo    ContactInfo     `json:"contactInfo"`
	AboutMe        string          `json:"aboutMe"`
	Experience     []Experience    `json:"experience"`
	Skills         Skills          `json:"skills"`
	Certifications []Certification `json:"certifications"`
}

type ContactInfo struct {
	Location string `json:"location"`
	Phone    string `json:"phone"`
	Mail     string `json:"mail"`
	LinkedIn string `json:"linkedIn"`
	Github   string `json:"github"`
}

type Experience struct {
	CompanyName  string   `json:"companyName"`
	FromDate     string   `json:"fromDate"`
	ToDate       string   `json:"toDate"`
	TechStack    []string `json:"techStack"`
	Achievements []string `json:"achievements"`
	Id           int      `json:"id"`
	Role         string   `json:"role"`
}

type Skills struct {
	ProgrammingLanguages []IndividualSkill `json:"programmingLanguages"`
	Frameworks           []IndividualSkill `json:"frameworks"`
	Databases            []IndividualSkill `json:"databases"`
}

type IndividualSkill struct {
	Name  string `json:"name"`
	Level string `json:"level"`
}

type Certification struct {
	Name         string `json:"name"`
	DateObtained string `json:"dateObtained"`
	Url          string `json:"url"`
}
