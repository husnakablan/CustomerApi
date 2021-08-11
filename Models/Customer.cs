using System;
using System.ComponentModel.DataAnnotations.Schema;
using System.Text.Json;
using System.Text.Json.Serialization;

namespace CustomerApi.Models
{
    public class Customer
    {
        public Customer(string Name, string Surname, string PhoneNumber)
        {
            this.Name = Name;
            this.Surname = Surname;
            this.PhoneNumber = PhoneNumber;
            this.CreatedBy = Constants.GeneralConstants.LoginUser;
        }

        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int Id { get; set; }

        public string Name { get; set; }

        public string Surname { get; set; }

        public string PhoneNumber { get; set; }

        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public DateTime CreatedDate { get; set; }

        public string CreatedBy { get; set; }

        public Nullable<System.DateTime> LastModifiedDate { get; set; }

        public string LastModifiedBy { get; set; }

        [JsonIgnore]
        public bool IsDeleted { get; set; }

    }
}
