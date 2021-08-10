using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace CustomerApi.Models
{
    public class Customer
    {
        public Customer(int Id, string Name, string Surname, string PhoneNumber)
        {
            this.Id = Id;
            this.Name = Name;
            this.Surname = Surname;
            this.PhoneNumber = PhoneNumber;
            this.CreatedDate = DateTime.Now;
            this.CreatedBy = Constants.GeneralConstants.LoginUser;
        }

        public int Id { get; set; }

        public string Name { get; set; }

        public string Surname { get; set; }

        public string PhoneNumber { get; set; }

        public DateTime CreatedDate { get; set; }

        public string CreatedBy { get; set; }

        public Nullable<System.DateTime> LastModifiedDate { get; set; }

        public string LastModifiedBy { get; set; }

    }
}
