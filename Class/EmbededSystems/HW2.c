
#include <stdio.h>

struct Candidate {
  char name[20];
  int votes;
};

void castVote(struct Candidate candidates[], int choice) {
  if (choice == 0 || choice == 1) {
    candidates[choice].votes++;
  } else {
    printf("Invalid choice! Vote not counted.\n");
  }
}

void displayResults(struct Candidate candidates[], int n) {
  printf("\n--- Voting Results ---\n");
  for (int i = 0; i < n; i++) {
    printf("%s: %d votes\n", candidates[i].name, candidates[i].votes);
  }

  if (candidates[0].votes > candidates[1].votes)
    printf("Winner: %s\n", candidates[0].name);
  else if (candidates[1].votes > candidates[0].votes)
    printf("Winner: %s\n", candidates[1].name);
  else
    printf("It’s a tie!\n");
}

int main() {
  struct Candidate candidates[2] = {{"Donkey", 0}, {"Elephant", 0}};
  int choice;

  printf("Voting System (0 = Donkey, 1 = Elephant)\n");
  for (int i = 0; i < 5; i++) {
    printf("Voter %d, enter your choice: ", i + 1);
    scanf("%d", &choice);
    castVote(candidates, choice);
  }

  displayResults(candidates, 2);

  return 0;
}
