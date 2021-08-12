using System;
using System.ComponentModel.DataAnnotations.Schema;
using System.Text.Json.Serialization;

namespace CustomerApi.Models
{
    [Table("customer")]
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

        [Column("name")]
        public string Name { get; set; }

        [Column("surname")]
        public string Surname { get; set; }

        [Column("phone_number")]
        public string PhoneNumber { get; set; }

        [Column("created_date")]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public DateTime CreatedDate { get; set; }

        [Column("created_by")]
        public string CreatedBy { get; set; }

        [Column("last_modified_date")]
        public Nullable<System.DateTime> LastModifiedDate { get; set; }

        [Column("last_modified_by")]
        public string LastModifiedBy { get; set; }

        [Column("is_deleted")]
        [JsonIgnore]
        public bool IsDeleted { get; set; }

    }
}
