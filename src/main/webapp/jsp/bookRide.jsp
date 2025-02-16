<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.servlet.http.*, javax.servlet.*" %>
<%@ include file="header.jsp" %> <!-- This includes the navigation bar -->
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Book a Ride</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <script>
        function updateFare() {
            var distance = document.getElementById("distance").value;
            var vehicleSelect = document.getElementById("vehicle");
            var perKmRate = vehicleSelect.options[vehicleSelect.selectedIndex].getAttribute("data-rate");
            var isPeakHour = document.getElementById("peak_hour").checked;

            var baseFare = 5; // Base fare
            var peakHourCharge = isPeakHour ? 3 : 0; // Peak hour extra charge

            if (distance && perKmRate) {
                var totalFare = baseFare + (distance * parseFloat(perKmRate)) + peakHourCharge;
                document.getElementById("fare").value = totalFare.toFixed(2);
            }
        }
    </script>
</head>
<body>
    <div class="container mt-5">
        <h2>Book a Ride</h2>
        <form action="../BookRideServlet" method="post">
            <div class="mb-3">
                <label class="form-label">Pickup Location:</label>
                <input type="text" name="pickup_location" class="form-control" required>
            </div>
            <div class="mb-3">
                <label class="form-label">Destination:</label>
                <input type="text" name="destination" class="form-control" required>
            </div>
            <div class="mb-3">
                <label class="form-label">Distance (km):</label>
                <input type="number" id="distance" name="distance" class="form-control" oninput="updateFare()" required>
            </div>
            <div class="mb-3">
                <label class="form-label">Select Vehicle:</label>
                <select id="vehicle" name="vehicle_id" class="form-control" onchange="updateFare()" required>
                    <option value="" disabled selected>Select a vehicle</option>
                    <%
                        try (Connection conn = com.vehicle.utils.DBConnection.getConnection()) {
                            String sql = "SELECT vehicle_id, model, capacity, per_km_rate FROM vehicles WHERE status='available'";
                            PreparedStatement stmt = conn.prepareStatement(sql);
                            ResultSet rs = stmt.executeQuery();
                            while (rs.next()) {
                    %>
                                <option value="<%= rs.getInt("vehicle_id") %>" data-rate="<%= rs.getDouble("per_km_rate") %>">
                                    <%= rs.getString("model") %> - <%= rs.getInt("capacity") %> Seats ($<%= rs.getDouble("per_km_rate") %>/km)
                                </option>
                    <%
                            }
                        } catch (Exception e) {
                            e.printStackTrace();
                        }
                    %>
                </select>
            </div>
            <div class="mb-3 form-check">
                <input type="checkbox" id="peak_hour" name="peak_hour" class="form-check-input" onclick="updateFare()">
                <label class="form-check-label">Peak Hour?</label>
            </div>
            <div class="mb-3">
                <label class="form-label">Estimated Fare ($):</label>
                <input type="text" id="fare" name="fare" class="form-control" readonly>
            </div>
            <button type="submit" class="btn btn-primary">Book Ride</button>
        </form>
    </div>
</body>
</html>
