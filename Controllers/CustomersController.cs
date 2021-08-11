using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using CustomerApi.Models;
using Microsoft.Extensions.Logging;

namespace CustomerApi.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class CustomersController : ControllerBase
    {
        private readonly CustomerContext _context;
        private readonly ILogger _logger;

        public CustomersController(CustomerContext context,ILogger<CustomersController> logger)
        {
            _context = context;
            _logger = logger;
        }

        // GET: api/Customers
        [HttpGet]
        public async Task<ActionResult<IEnumerable<Customer>>> GetCustomers()
        {
            _logger.LogInformation("Sayisi: " + _context.Customer.Count<Customer>());
            return await _context.Customer.ToListAsync();
        }

        // GET: api/Customers/5
        [HttpGet("{id}")]
        public async Task<ActionResult<Customer>> GetCustomer(int id)
        {
            var customer = await _context.Customer.FindAsync(id);

            if (customer == null)
            {
                _logger.LogWarning( id + " numaralı kayıt bulunamadı.");
                return NotFound();
            }

            return customer;
        }

        // PUT: api/Customers/5
        // To protect from overposting attacks, enable the specific properties you want to bind to, for
        // more details, see https://go.microsoft.com/fwlink/?linkid=2123754.
        [HttpPut("{id}")]
        public async Task<IActionResult> PutCustomer(int id, Customer customer)
        {
            if (id != customer.Id)
            {
                _logger.LogWarning( "Bad request");
                return BadRequest();
            }

            var updatedCustomer = _context.Customer.Find(id);

            if (updatedCustomer == null)
            {
                _logger.LogWarning(id + " numaralı kayıt bulunamadı.");
                return NotFound();
            }

            updatedCustomer.Name = customer.Name;
            updatedCustomer.Surname = customer.Surname;
            updatedCustomer.PhoneNumber = customer.PhoneNumber;
            updatedCustomer.LastModifiedBy = Constants.GeneralConstants.LoginUser;

            _context.Entry(updatedCustomer).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException e)
            {
                _logger.LogError(id + " numaralı kayıt güncellenirken hata alındı.", e);
                if (!CustomerExists(id))
                {
                    return NotFound();
                }
                else
                {
                    throw;
                }
            }

            return NoContent();
        }

        // POST: api/Customers
        // To protect from overposting attacks, enable the specific properties you want to bind to, for
        // more details, see https://go.microsoft.com/fwlink/?linkid=2123754.
        [HttpPost]
        public async Task<ActionResult<Customer>> PostCustomer(Customer customer)
        {
            if (CustomerExists(customer.Id)) {
                string errorMessage = customer.Id + " numaralı kayıt zaten mevcut.";
                _logger.LogError(errorMessage);
                throw new Exception(errorMessage);
            }
            _context.Customer.Add(customer);
            await _context.SaveChangesAsync();

            return CreatedAtAction("GetCustomer", new { id = customer.Id }, customer);
        }

        // DELETE: api/Customers/5
        [HttpDelete("{id}")]
        public async Task<ActionResult<Customer>> DeleteCustomer(int id)
        {
            var customer = await _context.Customer.FindAsync(id);
            if (customer == null)
            {
                return NotFound();
            }

            customer.IsDeleted = true;
            customer.LastModifiedBy = Constants.GeneralConstants.LoginUser;

            _context.Entry(customer).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException e)
            {
                _logger.LogError(id + " numaralı kayıt silinirken hata alındı.", e);
                if (!CustomerExists(id))
                {
                    return NotFound();
                }
                else
                {
                    throw;
                }
            }

            return customer;
        }

        private bool CustomerExists(int id)
        {
            return _context.Customer.Any(e => e.Id == id);
        }
    }
}
