import {
  FlatList,
  Image,
  ScrollView,
  StyleSheet,
  Text,
  TextInput,
  TouchableOpacity,
  View,
} from "react-native";

import { useState } from "react";

export default function App() {
  const [cities] = useState(
    [
      {
        id: "1",
        name: "Helsinki",
        temp: "21°C",
        desc: "Sunny",
        icon: "https://img.icons8.com/?size=100&id=8LM7-CYX4BPD&format=png&color=000000",
      },
      {
        id: "2",
        name: "Tampere",
        temp: "16°C",
        desc: "Cloudy",
        icon: "https://img.icons8.com/?size=100&id=UyNm3S4bECd7&format=png&color=000000",
      },
      {
        id: "3",
        name: "Yyväskylä",
        temp: "12°C",
        desc: "Rainy",
        icon: "https://img.icons8.com/?size=100&id=ulJA5JddHJKv&format=png&color=000000",
      },
      {
        id: "4",
        name: "Oulu",
        temp: "25°C",
        desc: "Stormy",
        icon: "https://img.icons8.com/?size=100&id=ESeqfDjC5eVO&format=png&color=000000",
      },
    ].flatMap((i) => [i, i, i])
  );

  return (
    <ScrollView contentContainerStyle={styles.container}>
      <Text style={styles.title}>Weather Dashboard</Text>

      <View style={styles.searchRow}>
        <TextInput
          placeholder="Enter City Name..."
          style={styles.searchInput}
        />

        <TouchableOpacity style={styles.addButton}>
          <Text style={styles.addButtonText}>+ Add</Text>
        </TouchableOpacity>
      </View>

      <FlatList
        data={cities}
        renderItem={({ item }) => (
          <View style={styles.cityCard}>
            <View style={styles.cityCardHeader}>
              <Text style={styles.cityName}>{item.name}</Text>
              <Text style={styles.cityTemp}>{item.temp}</Text>
            </View>

            <Image style={styles.cityIcon} source={{ uri: item.icon }} />
            <Text style={styles.cityDesc}>{item.desc}</Text>
          </View>
        )}
        keyExtractor={(item) => item.id}
        contentContainerStyle={styles.cities}
      />
    </ScrollView>
  );
}

const styles = StyleSheet.create({
  container: {
    flexGrow: 1,
    backgroundColor: "#F5F5F5",
    paddingVertical: 60,
    paddingHorizontal: 24,
  },
  title: {
    fontSize: 28,
    fontWeight: "bold",
    marginBottom: 24,
    textAlign: "center",
  },
  searchRow: {
    flexDirection: "row",
    alignItems: "center",
    gap: 16,
    marginBottom: 24,
  },
  searchInput: {
    flex: 1,
    borderWidth: 1,
    borderRadius: 8,
    padding: 12,
    borderColor: "#CCC",
    backgroundColor: "#FFF",
  },
  addButton: {
    backgroundColor: "#3232FF",
    paddingVertical: 12,
    paddingHorizontal: 16,
    borderRadius: 8,
  },
  addButtonText: {
    color: "#FFF",
    fontWeight: "bold",
  },
  cities: {
    paddingBottom: 30,
    gap: 16,
  },
  cityCard: {
    backgroundColor: "#FFF",
    borderRadius: 12,
    padding: 24,
    shadowColor: "#000",
    shadowOpacity: 0.1,
    shadowOffset: { width: 0, height: 2 },
    shadowRadius: 5,
    elevation: 3,
    alignItems: "center",
  },
  cityCardHeader: {
    flexDirection: "row",
    justifyContent: "space-between",
    width: "100%",
    marginBottom: 16,
  },
  cityName: {
    fontSize: 20,
    fontWeight: "600",
  },
  cityTemp: {
    fontSize: 32,
    fontWeight: "bold",
    color: "#FF7272",
  },
  cityDesc: {
    fontSize: 16,
  },
  cityIcon: {
    width: 40,
    height: 40,
    marginBottom: 8,
  },
});
